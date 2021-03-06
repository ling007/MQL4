//+------------------------------------------------------------------+
//|                                                     0-newsEA.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int Magic=1112;
extern double Lots=0.01;
extern bool isAutoLots=false;
extern double TP=25;
extern double SL=20;
extern double TrailingStop=15;
extern double gap=100;

extern int timedelay=8;
string sSymbol;
string suffix="";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   suffix=StringSubstr(Symbol(),6,StringLen(Symbol())-6);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Check_News_Calendar();
   OrderNews();

   Comment("\nLot: "+DoubleToStr(LotsSize(Symbol()),2),
           "\n"+TimeCurrent()
           );
  }
//+------------------------------------------------------------------+
void OrderNews()
  {
   int h,m;
   for(int i=0;i<NewsTotal;i++)
     {
      sSymbol=NewsCurrency[i]+suffix;
      TrailOrderStop(sSymbol);

      h = TimeHour(NewsTime[i])+GMTOffset;
      m = TimeMinute(NewsTime[i]);
      DeletePendingOrdert(m,timedelay,sSymbol);

      if(m==0)
        {
         h = h -1;
         m = 59;
        }
      else
         m=m -1;

      if(TimeHour(TimeCurrent())==h && TimeMinute(TimeCurrent())==m)
        {
         if(TimeSeconds(TimeCurrent())>=55)
           {
            if(NewsCurrency[i]=="GBPUSD") TP=45;
            if(!IfOrderDoesNotExist(4,sSymbol) && !IfOrderDoesNotExist(5,sSymbol))
               PendingOrder(sSymbol);
           }
        }
      if(IfOrderDoesNotExist(0,sSymbol)) DeletePendingOrder(5,sSymbol);
      if(IfOrderDoesNotExist(1,sSymbol)) DeletePendingOrder(4,sSymbol);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IfOrderDoesNotExist(int Type,string symbol)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==Type && OrderSymbol()==symbol && OrderMagicNumber()==Magic)
           {
            return(1);
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrder(int Mode,string symbol)
  {
   while(!IsTradeAllowed()) Sleep(100);
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==Mode && OrderSymbol()==symbol && OrderMagicNumber()==Magic)
           {
            bool ret=OrderDelete(OrderTicket(),CLR_NONE);

            if(ret==false)
              {
               Print("OrderDelete() error - ",GetLastError());
              }
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrdert(int minute,int tseconds,string symbol)
  {
   while(!IsTradeAllowed()) Sleep(100);
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()>=4 && OrderSymbol()==symbol && OrderMagicNumber()==Magic)
            if(TimeMinute(TimeCurrent())==minute && TimeSeconds(TimeCurrent())>tseconds)
              {
               bool ret=OrderDelete(OrderTicket(),CLR_NONE);

               if(ret==false)
                 {
                  Print("OrderDelete() error - ",GetLastError());
                 }
              }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PendingOrder(string symbol)
  {
   int res;

   while(!IsTradeAllowed()) Sleep(100);
   double ask = MarketInfo(symbol,MODE_ASK);
   double bid = MarketInfo(symbol,MODE_BID);
   double digits = MarketInfo(symbol,MODE_DIGITS);
   double point = MarketInfo(symbol,MODE_POINT);
   
   res = OrderSend(symbol ,OP_BUYSTOP,LotsSize(symbol),NormalizeDouble(ask+gap*point,digits),3,NormalizeDouble(bid-SL*point*10,digits),NormalizeDouble(ask+TP*point*10,digits),NULL,Magic);
   res = OrderSend(symbol ,OP_SELLSTOP,LotsSize(symbol),NormalizeDouble(bid-gap*point,digits),3,NormalizeDouble(ask+SL*point*10,digits),NormalizeDouble(bid-TP*point*10,digits),NULL,Magic);
   if(res>0)
     {
      Print("everything is ok!");
     }
   else
      Print(symbol+" pending error !!! "+GetLastError());
  }
// -------------------------------------------------
// TrailOrderStop()
// -------------------------------------------------
void TrailOrderStop(string symbol)
  {
   if(TrailingStop==0) return;
   int direction;
   double trail_val,old_stopv,new_stopv,gap_price,gap_stops;
   double digits = MarketInfo(symbol,MODE_DIGITS);
   double point = MarketInfo(symbol,MODE_POINT);
   
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==Magic)
           {
            direction=(1-2 *(OrderType()%2));

            trail_val = NormalizeDouble(TrailingStop * point * direction, digits);
            old_stopv = NormalizeDouble(iif(direction>0 || OrderStopLoss()!=0, OrderStopLoss(), 999999), digits);
            new_stopv = NormalizeDouble(PriceClose(direction,symbol) - trail_val, digits);
            gap_price = NormalizeDouble(new_stopv - OrderOpenPrice(), digits);
            gap_stops = NormalizeDouble(new_stopv - old_stopv, digits);

            //double new_takep = NormalizeDouble(OrderTakeProfit(), Digits);
            //double gap_tp_sl = NormalizeDouble(new_takep - new_stopv, Digits);

            if(gap_price*direction>10*point && gap_stops*direction>=point && (OrderProfit()+OrderCommission()+OrderSwap()>1))
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),new_stopv,OrderTakeProfit(),0);
              }
           }
        }
  }
//+------------------------------------------------------------------+
double LotsSize(string symbol)
  {
   double lot=Lots;
   if(!isAutoLots) return(lot);
   lot=AccountFreeMargin()/100000*AccountLeverage()*0.2;
   if(lot>MarketInfo(symbol,MODE_MAXLOT))
      lot=MarketInfo(symbol,MODE_MAXLOT);
   return(NormalizeDouble(lot,2));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double PriceOpen(int direction,string symbol)
  {
   return(iif(direction > 0, MarketInfo(symbol,MODE_BID), MarketInfo(symbol,MODE_ASK)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double PriceClose(int direction,string symbol)
  {
   return(iif(direction > 0, MarketInfo(symbol,MODE_ASK), MarketInfo(symbol,MODE_BID)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iif(bool condition,double ifTrue,double ifFalse)
  {
   if(condition) return(ifTrue);
   return(ifFalse);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
extern int GMTOffset=-5;//夏令时=-5，冬令时=-6
datetime NewsTime[20];
string NewsCurrency[20];
int NewsStar[20];
int NewsTotal;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Read_jin10_Calendar(string fName)
  {
   string sIndex[20];
   string sTime[20];          // Date   
   string sCountry[20];        // 
   string sDataname[20];        //
   string sPublicdate[20];
   string sStar[20];      // 

   int handle=FileOpen(fName,FILE_CSV|FILE_READ,',');
   if(handle<1)
     {
      Print("File not found ",GetLastError());
      return;
     }
   int i=0;

   while(!FileIsEnding(handle))
     {
      sIndex[i]=FileReadString(handle);
      sTime[i]=FileReadString(handle);
      sCountry[i]=FileReadString(handle);
      sDataname[i]=FileReadString(handle);
      sPublicdate[i]=StringSubstr(FileReadString(handle),0,10);
      sStar[i]=FileReadString(handle);

      if((sCountry[i] == "法国")) NewsCurrency[i]="EURUSD";
      if((sCountry[i] == "德国")) NewsCurrency[i]="EURUSD";
      if((sCountry[i] == "欧元区")) NewsCurrency[i]="EURUSD";
      if((sCountry[i] == "美国")) NewsCurrency[i]="EURUSD";
      if((sCountry[i] == "英国")) NewsCurrency[i]="GBPUSD";
      if((sCountry[i] == "日本")) NewsCurrency[i]="USDJPY";
      if((sCountry[i] == "瑞士")) NewsCurrency[i]="USDCHF";
      if((sCountry[i] == "加拿大")) NewsCurrency[i]="USDCAD";
      if((sCountry[i] == "澳大利亚")) NewsCurrency[i]="AUDUSD";
      if((sCountry[i] == "新西兰")) NewsCurrency[i]="NZDUSD";
      NewsTime[i]= StrToTime(sTime[i]);
      NewsStar[i]=StrToInteger(sStar[i]);
      Print(sPublicdate[i]," ",sTime[i]," ",sCountry[i]," ",sDataname[i]," ",NewsCurrency[i] );
      i++;
     }
   FileClose(handle);
   NewsTotal=i;
  }
//********************************************************************************************
void Check_News_Calendar()
  {

   datetime cTime=iTime(NULL,PERIOD_D1,0);
   static datetime prevTime;

   if((TimeCurrent()>cTime && cTime>prevTime))
     {
      string m,d;
      if(TimeMonth(TimeCurrent())<10)
        {
         m="0"+TimeMonth(TimeCurrent());
        }
      else
         m=TimeMonth(TimeCurrent());
      if(TimeDay(TimeCurrent())<10)
        {
         d="0"+TimeDay(TimeCurrent());
        }
      else
         d=TimeDay(TimeCurrent());
      string cName=m+d+"news.csv"; Print("file name : ", cName);
      if(cName!="")
        {
         Read_jin10_Calendar(cName);
         prevTime=cTime;
        }
     }
  }
//+------------------------------------------------------------------+
