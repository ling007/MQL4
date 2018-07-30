//+------------------------------------------------------------------+
//|                                           101-ProtectAccount.mq4 |
//|                                                   Copyright 2017 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
extern int Magic=101;  
extern double ProfitStopLoss=-660.0;
extern double TakeProfit=1000.0;
extern bool EnableLocking=TRUE;

double invailNum=-999999.0;
double basketProfits=0.0;
double preLockProfits=invailNum;
double lockProfits=invailNum;
double oProfit;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAll()
  {
   int oType;
   bool CAS;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS);
      oType=OrderType();
      CAS=FALSE;
      switch(oType)
        {
         case OP_BUY:
            if(OrderMagicNumber()==Magic)
               CAS=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Red);
            break;
         case OP_SELL:
            if(OrderMagicNumber()==Magic)
               CAS=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Red);
            break;
         case OP_BUYLIMIT:
         case OP_BUYSTOP:
         case OP_SELLLIMIT:
         case OP_SELLSTOP:
            CAS=OrderDelete(OrderTicket());
        }
     }

   ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   bool profitLock;
   double Lots=1;
   oProfit=0.0;

   if(OrdersTotal()==0)
     {
      ProfitStopLoss= -660;
      basketProfits = 0;
      preLockProfits= invailNum;
      lockProfits=invailNum;
     }
   basketProfits=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      Lots=OrderLots();
      if(OrderMagicNumber()==Magic)
        oProfit=OrderProfit()+OrderSwap()+OrderCommission();
      basketProfits+=oProfit;
     }
   Lots=Lots*10;
   if(basketProfits<=ProfitStopLoss*Lots || basketProfits>=TakeProfit*Lots) CloseAll();
   if(EnableLocking)
     {
      if(basketProfits >= 6000.0*Lots) CloseAll();
      if(basketProfits <= preLockProfits) CloseAll();
      if(basketProfits >= 5000.0*Lots && preLockProfits == 4310.0*Lots) lockProfits = 4810*Lots;
      if(basketProfits >= 4600.0*Lots && preLockProfits == 4110.0*Lots) lockProfits = 4410*Lots;
      if(basketProfits >= 4300.0*Lots && preLockProfits == 3810.0*Lots) lockProfits = 4110*Lots;
      if(basketProfits >= 4000.0*Lots && preLockProfits == 3410.0*Lots) lockProfits = 3810*Lots;
      if(basketProfits >= 3600.0*Lots && preLockProfits == 3110.0*Lots) lockProfits = 3410*Lots;
      if(basketProfits >= 3300.0*Lots && preLockProfits == 2810.0*Lots) lockProfits = 3110*Lots;
      if(basketProfits >= 3000.0*Lots && preLockProfits == 2410.0*Lots) lockProfits = 2810*Lots;
      if(basketProfits >= 2600.0*Lots && preLockProfits == 2110.0*Lots) lockProfits = 2410*Lots;
      if(basketProfits >= 2300.0*Lots && preLockProfits == 1810.0*Lots) lockProfits = 2110*Lots;
      if(basketProfits >= 2000.0*Lots && preLockProfits == 1410.0*Lots) lockProfits = 1810*Lots;
      if(basketProfits >= 1600.0*Lots && preLockProfits == 1110.0*Lots) lockProfits = 1410*Lots;
      if(basketProfits >= 1300.0*Lots && preLockProfits == 810.0*Lots) lockProfits = 1110*Lots;
      if(basketProfits >= 1000.0*Lots && preLockProfits == 610.0*Lots) lockProfits = 810*Lots;
      if(basketProfits >= 700.0*Lots && preLockProfits == 410.0*Lots) lockProfits = 610*Lots;
      if(basketProfits >= 500.0*Lots && preLockProfits == 310.0*Lots) lockProfits = 410*Lots;
      if(basketProfits >= 400.0*Lots && preLockProfits == 210.0*Lots) lockProfits = 310*Lots;
      if(basketProfits >= 300.0*Lots && preLockProfits == 170.0*Lots) lockProfits = 210*Lots;
      if(basketProfits >= 200.0*Lots && preLockProfits == 95.0*Lots) lockProfits = 170*Lots;
      if(basketProfits >= 150.0*Lots && preLockProfits == 65*Lots) lockProfits = 95*Lots;
      if(basketProfits >= 100.0*Lots && preLockProfits == invailNum) lockProfits = 65*Lots;
      if(lockProfits>preLockProfits) preLockProfits=lockProfits;
     }
   if(preLockProfits==invailNum || !EnableLocking) profitLock=FALSE;
   else profitLock=preLockProfits;
   Comment("ProfitProtect[14] by Trader101",
           "\nBasket Profit = $ ",DoubleToStr(basketProfits,2),
           "\nProfit Locked = $ ",DoubleToStr(profitLock,2),
           "\nLocked Profit = $ ",DoubleToStr(lockProfits,2),
           "\nStop Loss     = $ ",DoubleToStr(ProfitStopLoss,2),
           "\nTake Profit   = $ ",DoubleToStr(TakeProfit,2)
           );
//return (0);   
  }
//+------------------------------------------------------------------+
