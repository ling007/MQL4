//+------------------------------------------------------------------+
//|                                                     Training.mq4 |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Denis Orlov"
#property link      "http://denis-or-love.narod.ru"

#include <stdlib.mqh>

extern double lot=0.1;
extern bool isAutoLots=true;
extern int TP=45;
extern int SL=30;
extern int corner=3;

int PX=5,PYH=40,PYL=2,PYTresh=39,FSize=14;
color BClr=Green,SClr=Red,ClClr=Yellow,ProfClr=Green,LossClr=Red,NClr1=Blue;
int BuyX=5,BuyPX=50,SellX=100,SellPX=140,
OrPrX=200,OrLX=220,OrSlX=260,stepX=15;

int STicket=-1,BTicket=-1;
bool orderOpen=false;
string Pr="Training ";
double pp=10000;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   DrawLabels(Pr+"Buy",corner,BuyX,PYL,"Buy",NClr1,0,FSize);
   DrawLabels(Pr+"Buy Profit",corner,BuyPX,PYH,"",NClr1,0,FSize);
   DrawLabels(Pr+"Sell",corner,SellX,PYL,"Sell",NClr1,0,FSize);
   DrawLabels(Pr+"Sell Profit",corner,SellPX,PYH,"",NClr1,0,FSize);

   DrawLabels(Pr+"Orders Profit",corner,OrPrX,PYL,TP,BClr,0,FSize);
   DrawLabels(Pr+"Orders Lot",corner,OrLX,PYH,DoubleToStr(lot,corner),NClr1,0,FSize);
   DrawLabels(Pr+"Stop Loss",corner,OrSlX,PYL,SL,SClr,0,FSize);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pr);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   Control();
//----
   return(0);
  }
//+------------------------------------------------------------------+
void Control()
  {
   Comment("\n净值 =$ ",DoubleToString(AccountBalance(),2),
            "\n可用 =$ ",DoubleToString(AccountFreeMargin(),2),
            " \n盈利 =$ ",AccountProfit());

//Comment("BTicket = ",BTicket," ; STicket = ",STicket); 

   if(ObjectFind(Pr+"Orders Lot")>-1)
      lot=StrToDouble(ObjectDescription(Pr+"Orders Lot"));
   if(isAutoLots && OrdersTotal()==0)
     {
      pp= NormalizeDouble(Ask/Point/AccountLeverage()+(SL+7)*10,4);
      lot=NormalizeDouble(AccountFreeMargin()/pp,2);
      if(AccountFreeMargin()<110) 
         {lot=0.0;Comment("\nToo little money now!!! $ " +(string)AccountBalance());return;}

      if(lot>MarketInfo(Symbol(),MODE_MAXLOT)) lot=MarketInfo(Symbol(),MODE_MAXLOT);
     }
// else lot=0.1;
   if(ObjectFind(Pr+"Stop Loss")>-1)
      SL=StrToInteger(ObjectDescription(Pr+"Stop Loss"));
// else SL=30; 
   if(ObjectFind(Pr+"Orders Profit")>-1)
      TP=StrToInteger(ObjectDescription(Pr+"Orders Profit"));
// else TP=30;  

   DrawLabels(Pr+"Orders Profit",corner,OrPrX,PYL,TP,BClr,0,FSize);
   DrawLabels(Pr+"Orders Lot",corner,OrLX,PYH,DoubleToStr(lot,corner),NClr1,0,FSize);
   DrawLabels(Pr+"Stop Loss",corner,OrSlX,PYL,SL,SClr,0,FSize);

   if(OrdersTotal()==0 && orderOpen==true)
     {
      orderOpen=false;
      DrawLabels(Pr+"Buy",corner,BuyX,PYL,"Buy",NClr1,0,FSize);
      DrawLabels(Pr+"Sell",corner,SellX,PYL,"Sell",NClr1,0,FSize);
     }
//====================================
   for(int pos=OrdersTotal()-1; pos>=0; pos--)
     {
      if(OrderSelect(pos,SELECT_BY_POS,MODE_TRADES)==false) continue;

      if(BTicket==-1 && OrderType()==OP_BUY)
        {
         BTicket=OrderTicket();
         DrawLabels(Pr+"Buy",corner,BuyX,PYH,"Buy",BClr,0,FSize);
        }

      if(STicket==-1 && OrderType()==OP_SELL)
        {
         STicket=OrderTicket();
         DrawLabels(Pr+"Sell",corner,SellX,PYH,"Sell",SClr,0,FSize);
        }

     }
//=================================
   int y=ObjectGet(Pr+"Buy",OBJPROP_YDISTANCE);

   if(y>PYTresh && BTicket<0)
     {
      BTicket=OrderSend(Symbol(),OP_BUY,lot,nd(Ask),corner,
                        Ask-SL*Point*10,Ask+TP*Point*10,"",0,0,BClr);

      if(BTicket==-1)
        {
         int err=GetLastError();
         Comment(err,": ",ErrorDescription(err));
        }
      else
         orderOpen=true;

     }
   if(y<PYTresh)
     {
      if(BTicket!=-1)
        {
         OrderClose(BTicket,lot,nd(Bid),corner,ClClr);
         //
         BTicket=-1;
        }

      DrawLabels(Pr+"Buy",corner,BuyX,PYL,"Buy",NClr1,0,FSize);
      DrawLabels(Pr+"Buy Profit",corner,BuyPX,PYL,"",NClr1,0,FSize);

     }
//=================================
   y=ObjectGet(Pr+"Sell",OBJPROP_YDISTANCE);
   if(y>PYTresh && STicket<0)
     {
      STicket=OrderSend(Symbol(),OP_SELL,lot,nd(Bid),corner,Bid+SL*Point*10,Bid-TP*Point*10,"",0,0,SClr);

      if(STicket==-1)
        {
         err=GetLastError();
         Comment(err,": ",ErrorDescription(err));
        }
      else
         orderOpen=true;
     }

   if(y<PYTresh)
     {
      if(STicket!=-1)
        {
         OrderClose(STicket,lot,nd(Ask),corner,ClClr);

         STicket=-1;
        }
      DrawLabels(Pr+"Sell",corner,SellX,PYL,"Sell",NClr1,0,FSize);
      DrawLabels(Pr+"Sell Profit",corner,SellPX,PYL,"",NClr1,0,FSize);
     }

//==========================
   if(BTicket!=-1)
     {
      if(OrderSelect(BTicket,SELECT_BY_TICKET))
        {
         double Buy_Profit=OrderProfit();
         if(Buy_Profit<0) color clr=LossClr; else clr=ProfClr;
         DrawLabels(Pr+"Buy Profit",corner,BuyPX,PYH,DoubleToStr(Buy_Profit,1),clr,0,FSize);
         DrawLabels(Pr+"Buy",corner,BuyX,PYH,"Buy",BClr,0,FSize);
        }
      else
        {
         BTicket=-1;
         DrawLabels(Pr+"Buy",corner,BuyX,PYL,"Buy",NClr1,0,FSize);
         DrawLabels(Pr+"Buy Profit",corner,BuyPX,PYL,"",NClr1,0,FSize);
        }
     }

   if(STicket!=-1)
     {
      if(OrderSelect(STicket,SELECT_BY_TICKET))
        {
         double Sell_Profit=OrderProfit();
         if(Sell_Profit<0) clr=LossClr; else clr=ProfClr;
         DrawLabels(Pr+"Sell Profit",corner,SellPX,PYH,DoubleToStr(Sell_Profit,1),clr,0,FSize);
         DrawLabels(Pr+"Sell",corner,SellX,PYH,"Sell",SClr,0,FSize);
        }
      else
        {
         STicket=-1;
         DrawLabels(Pr+"Sell",corner,SellX,PYL,"Sell",NClr1,0,FSize);
         DrawLabels(Pr+"Sell Profit",corner,SellPX,PYL,"",NClr1,0,FSize);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLabels(string name,int corn,int X,int Y,string Text,color Clr=Green,int Win=0,int fFSize=10)
  {
   int Error=ObjectFind(name);
   if(Error!=Win)
     {
      ObjectCreate(name,OBJ_LABEL,Win,0,0);
     }

   ObjectSet(name,OBJPROP_CORNER,corn);
   ObjectSet(name,OBJPROP_XDISTANCE,X);
   ObjectSet(name,OBJPROP_YDISTANCE,Y);//  
   ObjectSetText(name,Text,fFSize,"Arial",Clr);
  }
//---------------
//------------------------------------- 
/*int DrawTrends(string name, datetime T1, double P1, datetime T2, double P2, color Clr, int W=1, string Text="", bool ray=false, int Win=0)
   {
     int Error=ObjectFind(name);
   if (Error!=Win)
    {  
      ObjectCreate(name, OBJ_TREND, Win,T1,P1,T2,P2);
    }
     
    ObjectSet(name, OBJPROP_TIME1 ,T1);
    ObjectSet(name, OBJPROP_PRICE1,P1);
    ObjectSet(name, OBJPROP_TIME2 ,T2);
    ObjectSet(name, OBJPROP_PRICE2,P2);
    ObjectSet(name, OBJPROP_RAY , ray);
    ObjectSet(name, OBJPROP_COLOR , Clr);
    ObjectSet(name, OBJPROP_WIDTH , W);
    ObjectSetText(name,Text);
   // WindowRedraw();
   }  */
//-------------------------------------
void Delete_My_Obj(string Prefix)
  {
   for(int k=ObjectsTotal()-1; k>=0; k--)
     {
      string Obj_Name=ObjectName(k);
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));

      if(Head==Prefix)
        {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
        }
     }
  }

double nd(double in){return(NormalizeDouble(in,Digits));}
//+------------------------------------------------------------------+
//| return error description                                         |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
  {
   string error_string;
//----
   switch(error_code)
     {
      //---- codes returned from trade server
      case 0:
      case 1:   error_string="no error";                                                  break;
      case 2:   error_string="common error";                                              break;
      case 3:   error_string="invalid trade parameters";                                  break;
      case 4:   error_string="trade server is busy";                                      break;
      case 5:   error_string="old version of the client terminal";                        break;
      case 6:   error_string="no connection with trade server";                           break;
      case 7:   error_string="not enough rights";                                         break;
      case 8:   error_string="too frequent requests";                                     break;
      case 9:   error_string="malfunctional trade operation (never returned error)";      break;
      case 64:  error_string="account disabled";                                          break;
      case 65:  error_string="invalid account";                                           break;
      case 128: error_string="trade timeout";                                             break;
      case 129: error_string="invalid price";                                             break;
      case 130: error_string="invalid stops";                                             break;
      case 131: error_string="invalid trade volume";                                      break;
      case 132: error_string="market is closed";                                          break;
      case 133: error_string="trade is disabled";                                         break;
      case 134: error_string="not enough money";                                          break;
      case 135: error_string="price changed";                                             break;
      case 136: error_string="off quotes";                                                break;
      case 137: error_string="broker is busy (never returned error)";                     break;
      case 138: error_string="requote";                                                   break;
      case 139: error_string="order is locked";                                           break;
      case 140: error_string="long positions only allowed";                               break;
      case 141: error_string="too many requests";                                         break;
      case 145: error_string="modification denied because order too close to market";     break;
      case 146: error_string="trade context is busy";                                     break;
      case 147: error_string="expirations are denied by broker";                          break;
      case 148: error_string="amount of open and pending orders has reached the limit";   break;
      //---- mql4 errors
      case 4000: error_string="no error (never generated code)";                          break;
      case 4001: error_string="wrong function pointer";                                   break;
      case 4002: error_string="array index is out of range";                              break;
      case 4003: error_string="no memory for function call stack";                        break;
      case 4004: error_string="recursive stack overflow";                                 break;
      case 4005: error_string="not enough stack for parameter";                           break;
      case 4006: error_string="no memory for parameter string";                           break;
      case 4007: error_string="no memory for temp string";                                break;
      case 4008: error_string="not initialized string";                                   break;
      case 4009: error_string="not initialized string in array";                          break;
      case 4010: error_string="no memory for array\' string";                             break;
      case 4011: error_string="too long string";                                          break;
      case 4012: error_string="remainder from zero divide";                               break;
      case 4013: error_string="zero divide";                                              break;
      case 4014: error_string="unknown command";                                          break;
      case 4015: error_string="wrong jump (never generated error)";                       break;
      case 4016: error_string="not initialized array";                                    break;
      case 4017: error_string="dll calls are not allowed";                                break;
      case 4018: error_string="cannot load library";                                      break;
      case 4019: error_string="cannot call function";                                     break;
      case 4020: error_string="expert function calls are not allowed";                    break;
      case 4021: error_string="not enough memory for temp string returned from function"; break;
      case 4022: error_string="system is busy (never generated error)";                   break;
      case 4050: error_string="invalid function parameters count";                        break;
      case 4051: error_string="invalid function parameter value";                         break;
      case 4052: error_string="string function internal error";                           break;
      case 4053: error_string="some array error";                                         break;
      case 4054: error_string="incorrect series array using";                             break;
      case 4055: error_string="custom indicator error";                                   break;
      case 4056: error_string="arrays are incompatible";                                  break;
      case 4057: error_string="global variables processing error";                        break;
      case 4058: error_string="global variable not found";                                break;
      case 4059: error_string="function is not allowed in testing mode";                  break;
      case 4060: error_string="function is not confirmed";                                break;
      case 4061: error_string="send mail error";                                          break;
      case 4062: error_string="string parameter expected";                                break;
      case 4063: error_string="integer parameter expected";                               break;
      case 4064: error_string="double parameter expected";                                break;
      case 4065: error_string="array as parameter expected";                              break;
      case 4066: error_string="requested history data in update state";                   break;
      case 4099: error_string="end of file";                                              break;
      case 4100: error_string="some file error";                                          break;
      case 4101: error_string="wrong file name";                                          break;
      case 4102: error_string="too many opened files";                                    break;
      case 4103: error_string="cannot open file";                                         break;
      case 4104: error_string="incompatible access to a file";                            break;
      case 4105: error_string="no order selected";                                        break;
      case 4106: error_string="unknown symbol";                                           break;
      case 4107: error_string="invalid price parameter for trade function";               break;
      case 4108: error_string="invalid ticket";                                           break;
      case 4109: error_string="trade is not allowed in the expert properties";            break;
      case 4110: error_string="longs are not allowed in the expert properties";           break;
      case 4111: error_string="shorts are not allowed in the expert properties";          break;
      case 4200: error_string="object is already exist";                                  break;
      case 4201: error_string="unknown object property";                                  break;
      case 4202: error_string="object is not exist";                                      break;
      case 4203: error_string="unknown object type";                                      break;
      case 4204: error_string="no object name";                                           break;
      case 4205: error_string="object coordinates error";                                 break;
      case 4206: error_string="no specified subwindow";                                   break;
      default:   error_string="unknown error";
     }
//----
   return(error_string);
  }
//+------------------------------------------------------------------+
