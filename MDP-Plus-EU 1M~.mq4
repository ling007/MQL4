
#property copyright "Copyright ?2011"
#property link      "http://www.metaquotes.net"



//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A


extern string Configuration = "==== Configuration ====";
extern int Magic = 0;
extern string OrderCmt = "";
extern string Suffix = "";
extern bool SetTime = false;
extern bool NDDmode = FALSE;
extern bool Show_Debug = FALSE;
extern bool Verbose = FALSE;
extern string TradingSettings = "==== Trade settings ====";
extern bool TradeALLCurrencyPairs = FALSE;
extern double MaxSpread = 5.0;
extern double TakeProfit = 10.0;
extern double StopLoss = 90.0;
extern double TrailingStart = 0.0;
extern double Commission = 7.0;
extern bool UseDynamicVolatilityLimit = TRUE;
extern double VolatilityMultiplier = 125.0;
extern double VolatilityLimit = 180.0;
extern bool UseVolatilityPercentage = TRUE;
extern double VolatilityPercentageLimit = 60.0;
extern bool UseMovingAverage = TRUE;
extern bool UseBollingerBands = TRUE;
extern double Deviation = 1.5;
extern int OrderExpireSeconds = 3600;
extern string Money_Management = "==== Money Management ====";
extern double MinLots = 0.01;
extern double MaxLots = 1000.0;
extern double Risk = 2.0;
extern string Screen_Shooter = "==== Screen Shooter ====";
extern bool TakeShots = FALSE;
extern int DelayTicks = 1;
extern int ShotsPerBar = 1;
string Gsa_272[26] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD", "EURJPY", "GBPJPY", "CHFJPY", "CADJPY", "AUDJPY", "NZDJPY", "EURCHF", "EURGBP", "EURCAD", "EURAUD",
      "EURNZD", "GBPCHF", "GBPAUD", "GBPCAD", "GBPNZD", "AUDCHF", "AUDCAD", "AUDNZD", "NZDCHF",
   "NZDCAD", "CADCHF"};
string Gsa_276[];
bool Gi_unused_280 = FALSE;
bool Gi_284 = TRUE;
bool Gi_288 = FALSE;
int G_period_292 = 3;
int Gi_296 = 0;
int g_digits = 0;
int G_slippage_304 = 3;
int Gia_308[30];
int Gi_312 = 0;
datetime G_time_316 = 0;
int G_count_320 = 0;
int Gi_324 = 0;
int Gi_328 = 0;
int Gi_332 = 0;
double G_pips_336 = 0.0;
double Gd_unused_344 = 0.0;
double G_lots_352 = 0.1;
double Gd_unused_360 = 0.4;
double Gd_368 = 1.0;
double G_pips_376 = 5.0;
double G_pips_384 = 10.0;
double G_pips_392 = 20.0;
double Gda_400[30];
double Gda_404[30];
double Gda_408[30];
double Gd_412;
double Gd_420;
int Gi_428;
int Gi_432 = -1;
int Gi_436 = 3000000;
int Gi_440 = 0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {

   VolatilityPercentageLimit = VolatilityPercentageLimit / 100.0 + 1.0;
   VolatilityMultiplier /= 10.0;
   ArrayInitialize(Gda_408, 0);
   VolatilityLimit *= Point;
   Commission = NorBouble(Commission * Point); 
   g_digits = Digits;
   int Li_0 = MathMax(MarketInfo(Symbol(), MODE_FREEZELEVEL), MarketInfo(Symbol(), MODE_STOPLEVEL));
   if (TakeProfit < Li_0) TakeProfit = Li_0;
   if (StopLoss < Li_0) StopLoss = Li_0;
   if (Gi_296 < Li_0) Gi_296 = Li_0;
   if (MathMod(Digits, 2) == 0.0) G_slippage_304 = 0;
   else Gi_312 = -1;
   if (MaxLots > MarketInfo(Symbol(), MODE_MAXLOT)) MaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
   if (MinLots < MarketInfo(Symbol(), MODE_MINLOT)) MinLots = MarketInfo(Symbol(), MODE_MINLOT);
   if (TradeALLCurrencyPairs == TRUE) f0_13();
   if (Magic < 0) f0_12();
   start();
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}
bool time_ok=false;
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (g_digits == 0) return (init());
   if(Hour()>=3 && Hour()<=8 )
     {  time_ok = true;  }
   else
      time_ok = false;  
   f0_10(Gda_400, Gda_404, Gia_308, Gd_368);
   if(SetTime && !time_ok) Comment("\nnot the trade time zone !!!");
   else
      f0_6();
   return (0);
}

// 689C35E4872BA754D7230B8ADAA28E48
void f0_6() {
   string Ls_0;
   string symbol_8;
   bool bool_16;
   bool Li_20;
   int Li_unused_24;
   bool Li_28;
   int Li_32;
   int Li_unused_36;
   int ticket_40;
   int datetime_44;
   int Li_48;
   int Li_52;
   int Li_56;
   int pos_60;
   int Li_64;
   int index_68;
   int count_72;
   double price_76;
   double price_84;
   double Ld_92;
   double Ld_100;
   double Ld_108;
   double Ld_116;
   double order_stoploss_124;
   double order_takeprofit_132;
   double Ld_140;
   double ihigh_148;
   double ilow_156;
   double Ld_164;
   double Ld_172;
   double Ld_180;
   double ibands_188;
   double ibands_196;
   double Ld_204;
   double Ld_212;
   double Ld_220;
   double Ld_228;
   double Ld_236;
   double Ld_244;
   double Ld_252;
   double Ld_260;
   double Ld_268;
   double Ld_276;
   if (G_time_316 < Time[0]) {
      G_time_316 = Time[0];
      G_count_320 = 0;
   } else G_count_320++;
   if (TradeALLCurrencyPairs == FALSE) {
      Gi_332 = 1;
      symbol_8 = Symbol();
   }
   for (int count_284 = 0; count_284 != Gi_332; count_284++) {
      symbol_8 = Gsa_276[index_68];
      ihigh_148 = iHigh(symbol_8, PERIOD_M1, 0);
      ilow_156 = iLow(symbol_8, PERIOD_M1, 0);
      Ld_212 = ihigh_148 - ilow_156;
      Ld_164 = iMA(symbol_8, PERIOD_M1, G_period_292, 0, MODE_LWMA, PRICE_LOW, 0);
      Ld_172 = iMA(symbol_8, PERIOD_M1, G_period_292, 0, MODE_LWMA, PRICE_HIGH, 0);
      Ld_180 = Ld_172 - Ld_164;
      Li_28 = Bid >= Ld_164 + Ld_180 / 2.0;
      ibands_188 = iBands(symbol_8, PERIOD_M1, G_period_292, Deviation, 0, PRICE_OPEN, MODE_UPPER, 0);
      ibands_196 = iBands(symbol_8, PERIOD_M1, G_period_292, Deviation, 0, PRICE_OPEN, MODE_LOWER, 0);
      Ld_204 = ibands_188 - ibands_196;
      Li_32 = Bid >= ibands_196 + Ld_204 / 2.0;
      Li_unused_36 = 0;
      if (UseMovingAverage == FALSE && UseBollingerBands == TRUE && Li_32 == 1) {
         Li_unused_36 = 1;
         Gd_412 = ibands_188;
         Gd_420 = ibands_196;
      } else {
         if (UseMovingAverage == TRUE && UseBollingerBands == FALSE && Li_28 == 1) {
            Li_unused_36 = 1;
            Gd_412 = Ld_172;
            Gd_420 = Ld_164;
         } else {
            if (UseMovingAverage == TRUE && UseBollingerBands == TRUE && Li_28 == 1 && Li_32 == 1) {
               Li_unused_36 = 1;
               Gd_412 = MathMax(ibands_188, Ld_172);
               Gd_420 = MathMin(ibands_196, Ld_164);
            }
         }
      }
      Ld_220 = MathMax(MarketInfo(symbol_8, MODE_FREEZELEVEL), MarketInfo(symbol_8, MODE_STOPLEVEL)) * Point;
      Ld_228 = Ask - Bid;
      if (Ld_220 > 1.0 * Point) {
         Li_20 = FALSE;
         Ld_100 = MaxSpread * Point;
         Ld_236 = G_pips_384 * Point;
         Ld_108 = G_pips_376 * Point;
      } else {
         Li_20 = TRUE;
         Ld_100 = G_pips_392 * Point;
         Ld_236 = G_pips_336 * Point;
         Ld_108 = TrailingStart * Point;
      }
      Ld_100 = MathMax(Ld_100, Ld_220);
      if (Li_20) Ld_236 = MathMax(Ld_236, Ld_220);
      ArrayCopy(Gda_408, Gda_408, 0, 1, 29);
      Gda_408[29] = Ld_228;
      if (Gi_324 < 30) Gi_324++;
      Ld_244 = 0;
      pos_60 = 29;
      for (int count_288 = 0; count_288 < Gi_324; count_288++) {
         Ld_244 += Gda_408[pos_60];
         pos_60--;
      }
      Ld_252 = Ld_244 / Gi_324;
      Ld_260 = NorBouble(Ask + Commission);
      Ld_268 = NorBouble(Bid - Commission);
      Ld_276 = Ld_252 + Commission;
      if (UseDynamicVolatilityLimit == TRUE) VolatilityLimit = Ld_276 * VolatilityMultiplier;
      Li_64 = 0;
      if (Ld_212 && VolatilityLimit && Gd_420 && Gd_412) {
         if (Ld_212 > VolatilityLimit) {
            Ld_92 = Ld_212 / VolatilityLimit;
            if (UseVolatilityPercentage == FALSE || (UseVolatilityPercentage == TRUE && Ld_92 > VolatilityPercentageLimit)) {
               if (Bid < Gd_420) Li_64 = -1;
               else
                  if (Bid > Gd_412) Li_64 = 1;
            }
         } else Ld_92 = 0;
      }
      Ld_116 = MathMax(Ld_220, Ld_116);
      if (Bid == 0.0 || MarketInfo(symbol_8, MODE_LOTSIZE) == 0.0) Ld_116 = 0;
      datetime_44 = TimeCurrent() + OrderExpireSeconds;
      if (MarketInfo(symbol_8, MODE_LOTSTEP) == 0.0) Li_48 = 5;
      else Li_48 = f0_7(0.1, MarketInfo(symbol_8, MODE_LOTSTEP));
      if (Risk < 0.001 || Risk > 100.0) {
         Comment("ERROR -- Invalid Risk Value.");
         return;
      }
      if (AccountBalance() <= 0.0) {
         Comment("ERROR -- Account Balance is " + DoubleToStr(MathRound(AccountBalance()), 0));
         return;
      }
      G_lots_352 = f0_3(symbol_8);
      index_68 = 0;
      count_72 = 0;
      for (pos_60 = 0; pos_60 < OrdersTotal(); pos_60++) {
         OrderSelect(pos_60, SELECT_BY_POS, MODE_TRADES);
         if (OrderMagicNumber() == Magic && OrderCloseTime() == 0) {
            if (OrderSymbol() != symbol_8) {
               count_72++;
               continue;
            }
            switch (OrderType()) {
            case OP_BUY:
               if (Gi_284) {
                  order_stoploss_124 = OrderStopLoss();
                  order_takeprofit_132 = OrderTakeProfit();
                  if (order_takeprofit_132 < NorBouble(Ld_260 + Ld_100) && Ld_260 + Ld_100 - order_takeprofit_132 > Ld_108) {
                     order_stoploss_124 = NorBouble(Bid - Ld_100);
                     order_takeprofit_132 = NorBouble(Ld_260 + Ld_100);
                     Gi_328 = GetTickCount();
                     bool_16 = OrderModify(OrderTicket(), 0, order_stoploss_124, order_takeprofit_132, datetime_44, Lime);
                     Gi_328 = GetTickCount() - Gi_328;
                     if (bool_16 > FALSE && TakeShots && (!IsTesting()) && (!Gi_288)) f0_4();
                  }
               }
               index_68++;
               break;
            case OP_SELL:
               if (Gi_284) {
                  order_stoploss_124 = OrderStopLoss();
                  order_takeprofit_132 = OrderTakeProfit();
                  if (order_takeprofit_132 > NorBouble(Ld_268 - Ld_100) && order_takeprofit_132 - Ld_268 + Ld_100 > Ld_108) {
                     order_stoploss_124 = NorBouble(Ask + Ld_100);
                     order_takeprofit_132 = NorBouble(Ld_268 - Ld_100);
                     Gi_328 = GetTickCount();
                     bool_16 = OrderModify(OrderTicket(), 0, order_stoploss_124, order_takeprofit_132, datetime_44, Orange);
                     Gi_328 = GetTickCount() - Gi_328;
                     if (bool_16 > FALSE && TakeShots && (!IsTesting()) && (!Gi_288)) f0_4();
                  }
               }
               index_68++;
               break;
            case OP_BUYSTOP:
               if (!Li_28) {
                  Ld_140 = OrderTakeProfit() - OrderOpenPrice() - Commission;
                  if (NorBouble(Ask + Ld_236) < OrderOpenPrice() && OrderOpenPrice() - Ask - Ld_236 > Ld_108) {
                     Gi_328 = GetTickCount();
                     bool_16 = OrderModify(OrderTicket(), NorBouble(Ask + Ld_236), NorBouble(Bid + Ld_236 - Ld_140), NorBouble(Ld_260 + Ld_236 + Ld_140), 0, Lime);
                     Gi_328 = GetTickCount() - Gi_328;
                  }
                  index_68++;
               } else OrderDelete(OrderTicket());
               break;
            case OP_SELLSTOP:
            default:
               if (Li_28) {
                  Ld_140 = OrderOpenPrice() - OrderTakeProfit() - Commission;
                  if (NorBouble(Bid - Ld_236) > OrderOpenPrice() && Bid - Ld_236 - OrderOpenPrice() > Ld_108) {
                     Gi_328 = GetTickCount();
                     bool_16 = OrderModify(OrderTicket(), NorBouble(Bid - Ld_236), NorBouble(Ask - Ld_236 + Ld_140), NorBouble(Ld_268 - Ld_236 - Ld_140), 0, Orange);
                     Gi_328 = GetTickCount() - Gi_328;
                  }
                  index_68++;
               } else OrderDelete(OrderTicket());
            }
         }
      }
      Li_unused_24 = 0;
      if (Gi_312 >= 0 || Gi_312 == -2) {
         Li_52 = NormalizeDouble(Bid / Point, 0);
         Li_56 = NormalizeDouble(Ask / Point, 0);
         if (Li_52 % 10 != 0 || Li_56 % 10 != 0) Gi_312 = -1;
         else {
            if (Gi_312 >= 0 && Gi_312 < 10) Gi_312++;
            else Gi_312 = -2;
         }
      }
      if (index_68 == 0 && Li_64 != 0 && NorBouble(Ld_276) <= NorBouble(MaxSpread * Point) && Gi_312 == -1) {
         if (Li_64 < 0) {
            Gi_328 = GetTickCount();
            if (Li_20) {
               price_76 = Ask + Gi_296 * Point;
               if (NDDmode) {
                  ticket_40 = OrderSend(symbol_8, OP_BUYSTOP, G_lots_352, price_76, G_slippage_304, 0, 0, OrderCmt, Magic, 0, Lime);
                  if (OrderSelect(ticket_40, SELECT_BY_TICKET)) OrderModify(OrderTicket(), OrderOpenPrice(), price_76 - StopLoss * Point, price_76 + TakeProfit * Point, datetime_44, Lime);
               } else {
                  ticket_40 = OrderSend(symbol_8, OP_BUYSTOP, G_lots_352, price_76, G_slippage_304, price_76 - StopLoss * Point, price_76 + TakeProfit * Point, OrderCmt, Magic, datetime_44,
                     Lime);
               }
               if (ticket_40 < 0) {
                  Li_unused_24 = 1;
                  Print("ERROR BUYSTOP : " + f0_0(Ask + Ld_236) + " SL:" + f0_0(Bid + Ld_236 - Ld_116) + " TP:" + f0_0(Ld_260 + Ld_236 + Ld_116));
                  Gi_328 = 0;
               } else {
                  Gi_328 = GetTickCount() - Gi_328;
                  PlaySound("news.wav");
                  Print("BUYSTOP : " + f0_0(Ask + Ld_236) + " SL:" + f0_0(Bid + Ld_236 - Ld_116) + " TP:" + f0_0(Ld_260 + Ld_236 + Ld_116));
               }
            } else {
               if (Bid - ilow_156 > 0.0) {
                  ticket_40 = OrderSend(symbol_8, OP_BUY, G_lots_352, Ask, G_slippage_304, 0, 0, OrderCmt, Magic, datetime_44, Lime);
                  if (ticket_40 < 0) {
                     Li_unused_24 = 1;
                     Print("ERROR BUY Ask:" + f0_0(Ask) + " SL:" + f0_0(Bid - Ld_116) + " TP:" + f0_0(Ld_260 + Ld_116));
                     Gi_328 = 0;
                  } else {
                     bool_16 = OrderModify(ticket_40, 0, NorBouble(Bid - Ld_116), NorBouble(Ld_260 + Ld_116), datetime_44, Lime);
                     Gi_328 = GetTickCount() - Gi_328;
                     PlaySound("news.wav");
                     Print("BUY Ask:" + f0_0(Ask) + " SL:" + f0_0(Bid - Ld_116) + " TP:" + f0_0(Ld_260 + Ld_116));
                  }
               }
            }
         } else {
            if (Li_64 > 0) {
               if (Li_20) {
                  price_84 = Bid - Gi_296 * Point;
                  Gi_328 = GetTickCount();
                  if (NDDmode) {
                     ticket_40 = OrderSend(symbol_8, OP_SELLSTOP, G_lots_352, price_84, G_slippage_304, 0, 0, OrderCmt, Magic, 0, Orange);
                     if (OrderSelect(ticket_40, SELECT_BY_TICKET)) OrderModify(OrderTicket(), OrderOpenPrice(), price_84 + StopLoss * Point, price_84 - TakeProfit * Point, datetime_44, Orange);
                  } else {
                     ticket_40 = OrderSend(symbol_8, OP_SELLSTOP, G_lots_352, price_84, G_slippage_304, price_84 + StopLoss * Point, price_84 - TakeProfit * Point, OrderCmt, Magic, datetime_44,
                        Orange);
                  }
                  if (ticket_40 < 0) {
                     Li_unused_24 = 1;
                     Print("ERROR SELLSTOP : " + f0_0(Bid - Ld_236) + " SL:" + f0_0(Ask - Ld_236 + Ld_116) + " TP:" + f0_0(Ld_268 - Ld_236 - Ld_116));
                     Gi_328 = 0;
                  } else {
                     Gi_328 = GetTickCount() - Gi_328;
                     PlaySound("news.wav");
                     Print("SELLSTOP : " + f0_0(Bid - Ld_236) + " SL:" + f0_0(Ask - Ld_236 + Ld_116) + " TP:" + f0_0(Ld_268 - Ld_236 - Ld_116));
                  }
               } else {
                  if (ihigh_148 - Bid < 0.0) {
                     ticket_40 = OrderSend(symbol_8, OP_SELL, G_lots_352, Bid, G_slippage_304, 0, 0, OrderCmt, Magic, datetime_44, Orange);
                     if (ticket_40 < 0) {
                        Li_unused_24 = 1;
                        Print("ERROR SELL Bid:" + f0_0(Bid) + " SL:" + f0_0(Ask + Ld_116) + " TP:" + f0_0(Ld_268 - Ld_116));
                        Gi_328 = 0;
                     } else {
                        bool_16 = OrderModify(ticket_40, 0, NorBouble(Ask + Ld_116), NorBouble(Ld_268 - Ld_116), datetime_44, Orange);
                        Gi_328 = GetTickCount() - Gi_328;
                        PlaySound("news.wav");
                        Print("SELL Bid:" + f0_0(Bid) + " SL:" + f0_0(Ask + Ld_116) + " TP:" + f0_0(Ld_268 - Ld_116));
                     }
                  }
               }
            }
         }
      }
      if (Gi_312 >= 0) Comment("Robot is initializing...");
      else {
         if (Gi_312 == -2) Comment("ERROR -- Instrument " + symbol_8 + " prices should have " + g_digits + " fraction digits on broker account");
         else {
            Ls_0 = TimeToStr(TimeCurrent()) + " Tick: " + f0_8(G_count_320);
            if (Show_Debug || Verbose) {
               Ls_0 = Ls_0 
               + "\n*** DEBUG MODE *** \nVolatility: " + f0_0(Ld_212) + ", VolatilityLimit: " + f0_0(VolatilityLimit) + ", VolatilityPercentage: " + f0_0(Ld_92);
               Ls_0 = Ls_0 
               + "\nPriceDirection: " + StringSubstr("BUY NULLSELL", Li_64 * 4 + 4, 4) + ", ImaHigh: " + f0_0(Ld_172) + ", ImaLow: " + f0_0(Ld_164) + ", BBandUpper: " + f0_0(ibands_188);
               Ls_0 = Ls_0 + ", BBandLower: " + f0_0(ibands_196) + ", Expire: " + TimeToStr(datetime_44, TIME_MINUTES) + ", NnumOrders: " + index_68;
               Ls_0 = Ls_0 
               + "\nTrailingLimit: " + f0_0(Ld_236) + ", TrailingDist: " + f0_0(Ld_100) + "; TrailingStart: " + f0_0(Ld_108) + ", UseStopOrders: " + Li_20;
            }
            Ls_0 = Ls_0 
            + "\nBid: " + f0_0(Bid) + ", Ask: " + f0_0(Ask) + ", AvgSpread: " + f0_0(Ld_252) + ", Commission: " + f0_0(Commission) + ", RealAvgSpread: " + f0_0(Ld_276) + ", Lots: " + f0_5(G_lots_352,
               Li_48) + ", Execution: " + Gi_328 + " ms";
            if (NorBouble(Ld_276) > NorBouble(MaxSpread * Point)) {
               Ls_0 = Ls_0 
                  + "\n" 
               + "The current spread (" + f0_0(Ld_276) + ") is higher than what has been set as MaxSpread (" + f0_0(MaxSpread * Point) + ") so no trading is allowed right now on this currency pair!";
            }
            Comment(Ls_0);
            if (index_68 != 0 || Li_64 != 0 || Verbose) f0_1(Ls_0);
         }
      }
   }
}

// 9B1AEE847CFB597942D106A4135D4FE6
void f0_10(double &Ada_0[30], double &Ada_4[30], int &Aia_8[30], double A_pips_12) {
   if (Aia_8[0] == 0 || MathAbs(Bid - Ada_0[0]) >= A_pips_12 * Point) {
      for (int Li_20 = 29; Li_20 > 0; Li_20--) {
         Ada_0[Li_20] = Ada_0[Li_20 - 1];
         Ada_4[Li_20] = Ada_4[Li_20 - 1];
         Aia_8[Li_20] = Aia_8[Li_20 - 1];
      }
      Ada_0[0] = Bid;
      Ada_4[0] = Ask;
      Aia_8[0] = GetTickCount();
   }
}

// 09CBB5F5CE12C31A043D5C81BF20AA4A
string f0_0(double Ad_0) {
   return (DoubleToStr(Ad_0, g_digits));
}

// 58B0897F29A3AD862616D6CBF39536ED
string f0_5(double Ad_0, int Ai_8) {
   return (DoubleToStr(Ad_0, Ai_8));
}

// 28EFB830D150E70A8BB0F12BAC76EF35
double NorBouble(double Ad_0) {
   return (NormalizeDouble(Ad_0, g_digits));
}

// 78BAA8FAE18F93570467778F2E829047
string f0_8(int Ai_0) {
   if (Ai_0 < 10) return ("00" + Ai_0);
   if (Ai_0 < 100) return ("0" + Ai_0);
   return ("" + Ai_0);
}

// 6ABA3523C7A75AAEA41CC0DEC7953CC5
double f0_7(double Ad_0, double Ad_8) {
   return (MathLog(Ad_8) / MathLog(Ad_0));
}

// 2569208C5E61CB15E209FFE323DB48B7
void f0_1(string As_0) {
   int Li_8;
   int Li_12 = -1;
   while (Li_12 < StringLen(As_0)) {
      Li_8 = Li_12 + 1;
      Li_12 = StringFind(As_0, 
      "\n", Li_8);
      if (Li_12 == -1) {
         Print(StringSubstr(As_0, Li_8));
         return;
      }
      Print(StringSubstr(As_0, Li_8, Li_12 - Li_8));
   }
}

// D1DDCE31F1A86B3140880F6B1877CBF8
void f0_13() {
   string Ls_unused_0;
   string Ls_8;
   double ask_16;
   Gi_332 = 0;
   for (int index_24 = 0; index_24 != Gi_332; index_24++) {
      Ls_8 = Gsa_272[index_24];
      ask_16 = MarketInfo(Ls_8 + Suffix, MODE_ASK);
      if (ask_16 != 0.0) {
         Gi_332++;
         ArrayResize(Gsa_276, Gi_332);
         Gsa_276[Gi_332 - 1] = Ls_8;
      } else Print("The broker does not support ", Ls_8);
   }
}

// AA5EA51BFAC7B64E723BF276E0075513
int f0_12() {
   string Ls_0 = Symbol();
   int str_len_8 = StringLen(Ls_0);
   int Li_12 = 0;
   for (int Li_16 = 0; Li_16 < str_len_8 - 1; Li_16++) Li_12 += StringGetChar(Ls_0, Li_16);
   Magic = AccountNumber() + Li_12;
   return (0);
}

// 5710F6E623305B2C1458238C9757193B
void f0_4() {
   int Li_0;
   if (ShotsPerBar > 0) Li_0 = MathRound(60 * Period() / ShotsPerBar);
   else Li_0 = 60 * Period();
   int Li_4 = MathFloor((TimeCurrent() - Time[0]) / Li_0);
   if (Time[0] != Gi_428) {
      Gi_428 = Time[0];
      Gi_432 = DelayTicks;
   } else
      if (Li_4 > Gi_436) f0_9("i");
   Gi_436 = Li_4;
   if (Gi_432 == 0) f0_9("");
   if (Gi_432 >= 0) Gi_432--;
}

// A9B24A824F70CC1232D1C2BA27039E8D
string f0_11(int Ai_0, int Ai_4) {
   for (string dbl2str_8 = DoubleToStr(Ai_0, 0); StringLen(dbl2str_8) < Ai_4; dbl2str_8 = "0" + dbl2str_8) {
   }
   return (dbl2str_8);
}

// 945D754CB0DC06D04243FCBA25FC0802
void f0_9(string As_0 = "") {
   Gi_440++;
   string Ls_8 = "SnapShot" + Symbol() + Period() + "\\" + Year() + "-" + f0_11(Month(), 2) + "-" + f0_11(Day(), 2) + " " + f0_11(Hour(), 2) + "_" + f0_11(Minute(),
      2) + "_" + f0_11(Seconds(), 2) + " " + Gi_440 + As_0 + ".gif";
   if (!WindowScreenShot(Ls_8, 640, 480)) Print("ScreenShot error: ", ErrorDescription(GetLastError()));
}

// 50257C26C4E5E915F022247BABD914FE
double f0_3(string A_symbol_0) {
   double lotstep_8 = MarketInfo(A_symbol_0, MODE_LOTSTEP);
   double Ld_ret_16 = AccountFreeMargin() * Risk / StopLoss / 100.0;
   Ld_ret_16 = MathFloor(Ld_ret_16 / lotstep_8) * lotstep_8;
   if (G_lots_352 > MaxLots) G_lots_352 = MaxLots;
   if (G_lots_352 < MinLots) G_lots_352 = MinLots;
   return (Ld_ret_16);
}
