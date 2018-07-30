/*
*/
#property copyright "ForexHacked 2.5"
#property link      "http://www.ForexHacked.com"

#import "wininet.dll"
   int InternetOpenA(string a0, int a1, string a2, string a3, int a4);
   int InternetOpenUrlA(int a0, string a1, string a2, int a3, int a4, int a5);
   int InternetReadFile(int a0, string a1, int a2, int& a3[]);
   int InternetCloseHandle(int a0);
#import

extern string User = "ForexH";
extern int MagicNumber = 816;
extern double Lots = 0.01;
extern double TakeProfit = 45.0;
extern double Booster = 1.7;
double Gd_120 = 0.0;
extern int PipStarter = 31;
double Gd_132 = 0.0;
int Gi_140 = 0;
int Gi_144 = 0;
extern int MaxBuyOrders = 9;
extern int MaxSellOrders = 9;
extern bool AllowiStopLoss = FALSE;
extern int iStopLoss = 300;
extern int StartHour = 0;
extern int StartMinute = 0;
extern int StopHour = 23;
extern int StopMinute = 55;
extern int StartingTradeDay = 0;
extern int EndingTradeDay = 7;
extern int slippage = 3;
extern bool allowTrending = FALSE;
extern int trendTrigger = 3;
extern int trendPips = 5;
extern int trendStoploss = 5;
int Gi_208 = 5000;
int Gi_212 = 0;
int Gi_216 = 0;
extern double StopLossPct = 100.0;
extern double TakeProfitPct = 100.0;
extern bool PauseNewTrades = FALSE;
extern int StoppedOutPause = 600;
double Gd_244;
bool Gi_260;
int Gi_264 = 7;
int Gi_268 = 0;
int Gi_272 = MODE_LWMA;
int Gi_276 = PRICE_WEIGHTED;
double Gd_280 = 0.25;
double Gd_288 = 0.2;
extern bool SupportECN = TRUE;
extern bool MassHedge = FALSE;
extern double MassHedgeBooster = 1.01;
extern int TradesDeep = 5;
extern string EA_Name = "ForexHacked 2.5";
int Gi_324;
double Gd_328;
int Gi_336;
bool Gi_340 = FALSE;
string Gs_344;
int Gi_352;
int Gi_356;
int Gi_360 = 0;
int Gi_364 = 1;
int Gi_368 = 3;
int Gi_372 = 250;
string Gs_376;
bool Gi_384;
bool Gi_388;
bool Gi_392;
bool Gi_396;
int Gi_400;
int Gi_404;
string Gs__hedged_408 = " hedged";
int Gi_416;

// CE0BE71E33226E4C1DB2BCEA5959F16B
void f0_13(string As_0) {
   if (Gi_416 >= 0) FileWrite(Gi_416, TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS) + ": " + As_0);
}

// 2D2FBD6CA086D7549AF7E2BF548A4FBE
int f0_4() {
   double Ld_4 = MarketInfo(Symbol(), MODE_MINLOT);
   for (int Li_0 = 0; Ld_4 < 1.0; Li_0++) Ld_4 = 10.0 * Ld_4;
   return (Li_0);
}

// 159CB923CB4BC0A6FBCC46813ED14865
double f0_2(double Ad_0) {
   double Ld_32;
   double Ld_8 = AccountEquity() - Gi_208;
   double Ld_16 = Gi_212;
   double Ld_24 = Gi_216;
   if (Gi_212 == 0 || Gi_216 == 0) Ld_32 = Ad_0;
   else {
      Ld_16 = Gi_208 * Ld_16 / 100.0;
      Print("tmp=" + Ld_8 + ",AccountEquity()=" + AccountEquity() + ",InitEquity=" + Gi_208);
      Ld_24 /= 100.0;
      if (Ld_8 > 0.0) Ld_8 = MathPow(Ld_24 + 1.0, Ld_8 / Ld_16);
      else {
         if (Ld_8 < 0.0) Ld_8 = MathPow(1 - Ld_24, MathAbs(Ld_8 / Ld_16));
         else Ld_8 = 1;
      }
      Ld_32 = NormalizeDouble(Ad_0 * Ld_8, f0_4());
      if (Ld_32 < MarketInfo(Symbol(), MODE_MINLOT)) Ld_32 = MarketInfo(Symbol(), MODE_MINLOT);
   }
   if (Ld_32 < 0.0) Print("ERROR tmp=" + Ld_8 + ",a=" + Ld_16 + ",b=" + Ld_24 + ",AccountEquity()=" + AccountEquity());
   f0_13("Equity=" + AccountEquity() + ",lots=" + Ld_32);
   return (Ld_32);
}

// 1BBC94D06E1F0D3B9CFC87C094EBA75D
int f0_3(bool Ai_0) {
   string Ls_4;
   if (Gi_352 == 0) {
      Ls_4 = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
      Gi_352 = InternetOpenA(Ls_4, Gi_360, "0", "0", 0);
      Gi_356 = InternetOpenA(Ls_4, Gi_364, "0", "0", 0);
   }
   if (Ai_0) return (Gi_356);
   return (Gi_352);
}

// 67B5F51F6CCDE3F6F9D86EE70C3F4037
int f0_6(string As_0, string &As_8) {
   int Lia_24[] = {1};
   string Ls_28 = "x";
   int Li_16 = InternetOpenUrlA(f0_3(0), As_0, "0", 0, -2080374528, 0);
   if (Li_16 == 0) return (0);
   int Li_20 = InternetReadFile(Li_16, Ls_28, Gi_372, Lia_24);
   if (Li_20 == 0) return (0);
   int Li_36 = Lia_24[0];
   for (As_8 = StringSubstr(Ls_28, 0, Lia_24[0]); Lia_24[0] != 0; As_8 = As_8 + StringSubstr(Ls_28, 0, Lia_24[0])) {
      Li_20 = InternetReadFile(Li_16, Ls_28, Gi_372, Lia_24);
      if (Lia_24[0] == 0) break;
      Li_36 += Lia_24[0];
   }
   Li_20 = InternetCloseHandle(Li_16);
   if (Li_20 == 0) return (0);
   return (1);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   FileClose(Gi_416);
   return (0);
}

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   if (Digits == 3) {
      Gd_132 = 10.0 * TakeProfit;
      Gi_140 = 10.0 * PipStarter;
      Gi_144 = 10.0 * iStopLoss;
      Gd_328 = 0.01;
   } else {
      if (Digits == 5) {
         Gd_132 = 10.0 * TakeProfit;
         Gi_140 = 10.0 * PipStarter;
         Gi_144 = 10.0 * iStopLoss;
         Gd_328 = 0.0001;
      } else {
         Gd_132 = TakeProfit;
         Gi_140 = PipStarter;
         Gi_144 = iStopLoss;
         Gd_328 = Point;
      }
   }
   if (Digits == 3 || Digits == 5) {
      trendTrigger = 10 * trendTrigger;
      trendPips = 10 * trendPips;
      trendStoploss = 10 * trendStoploss;
   }
   Gi_336 = MathRound((-MathLog(MarketInfo(Symbol(), MODE_LOTSTEP))) / 2.302585093);
   Gi_384 = FALSE;
   Gi_388 = FALSE;
   Gi_392 = FALSE;
   Gi_396 = FALSE;
   Gi_400 = -1;
   Gi_260 = FALSE;
   Gi_416 = FileOpen(WindowExpertName() + "_" + Time[0] + "_" + Symbol() + "_" + MagicNumber + ".log", FILE_WRITE);
   Gi_404 = -1;
   //if (IsDemo() == TRUE) 
   Gs_376 = "approved";
   //else {
   //   f0_6("http://www.forexhacked.com/query.php?accountnumber=" + AccountNumber() + "&login=" + User, Gs_376);
   //   Print("init is done");
   //   return (0);
   //}
   return (0);
}

// A88FE8FAEB651132C0CA6446B53FDF9B
int f0_9() {
   int Li_8;
   if (DayOfWeek() < StartingTradeDay || DayOfWeek() > EndingTradeDay) return (0);
   int Li_0 = 60 * TimeHour(TimeCurrent()) + TimeMinute(TimeCurrent());
   int Li_4 = 60 * StartHour + StartMinute;
   Li_8 = 60 * StopHour + Li_8;
   if (Li_4 == Li_8) return (1);
   if (Li_4 < Li_8) {
      if (!(Li_0 >= Li_4 && Li_0 < Li_8)) return (0);
      return (1);
   }
   if (Li_4 > Li_8) {
      if (!(Li_0 >= Li_4 || Li_0 < Li_8)) return (0);
      return (1);
   }
   return (0);
}

// 9F06A2DC3F2B8513E9EFCD640A153D6E
double f0_7(int Ai_0) {
   for (int Li_4 = OrdersTotal() - 1; Li_4 >= 0; Li_4--) {
      if (OrderSelect(Li_4, SELECT_BY_POS)) {
         if (OrderMagicNumber() == MagicNumber) {
            if (StringFind(OrderComment(), Gs__hedged_408) == -1) {
               f0_13("GetLastLotSize " + Ai_0 + ",OrderLots()=" + OrderLots());
               return (OrderLots());
            }
         }
      }
   }
   f0_13("GetLastLotSize " + Ai_0 + " wasnt found");
   return (0);
}

// A5475BEEA729819A4699A3F14CBC7B39
int f0_8(bool Ai_0 = FALSE) {
   int Li_4;
   double Ld_40;
   double Ld_8 = 0;
   double Ld_16 = 0;
   string Ls_24 = "";
   bool Li_32 = TRUE;
   if (TimeCurrent() - Gi_324 < 60) return (0);
   if (Ai_0 && (!Gi_392)) return (0);
   if (!GlobalVariableCheck("PERMISSION")) {
      GlobalVariableSet("PERMISSION", TimeCurrent());
      if (!SupportECN) {
         if (Ai_0) {
            if (OrderSelect(Gi_400, SELECT_BY_TICKET)) Ld_16 = OrderTakeProfit() - MarketInfo(Symbol(), MODE_SPREAD) * Point;
         } else Ld_8 = Ask + Gd_132 * Point;
      }
      if (Ai_0) Ls_24 = Gs__hedged_408;
      if (AllowiStopLoss == TRUE) Ld_16 = Ask - Gi_144 * Point;
      if (Ai_0) Ld_40 = NormalizeDouble(f0_7(1) * MassHedgeBooster, 2);
      else Ld_40 = f0_2(Gd_244);
      if (!SupportECN) Li_4 = OrderSend(Symbol(), OP_BUY, Ld_40, Ask, slippage, Ld_16, Ld_8, EA_Name + Ls_24, MagicNumber, 0, Green);
      else {
         Li_4 = OrderSend(Symbol(), OP_BUY, Ld_40, Ask, slippage, 0, 0, EA_Name + Ls_24, MagicNumber, 0, Green);
         Sleep(1000);
         OrderModify(Li_4, OrderOpenPrice(), Ld_16, Ld_8, 0, Black);
      }
      Gi_324 = TimeCurrent();
      if (Li_4 != -1) {
         if (!Ai_0) {
            Gi_400 = Li_4;
            f0_13("BUY hedgedTicket=" + Gi_400);
         } else {
            f0_13("BUY Hacked_ticket=" + Li_4);
            Gi_404 = 0;
         }
      } else {
         f0_13("failed sell");
         Li_32 = FALSE;
      }
   }
   GlobalVariableDel("PERMISSION");
   return (Li_32);
}

// B6832796D33422B67F3123C913057ADB
int f0_10(bool Ai_0 = FALSE) {
   int Li_4;
   double Ld_36;
   double Ld_8 = 0;
   double Ld_16 = 0;
   string Ls_24 = "";
   bool Li_32 = TRUE;
   if (TimeCurrent() - Gi_324 < 60) return (0);
   if (Ai_0 && (!Gi_396)) return (0);
   if (!GlobalVariableCheck("PERMISSION")) {
      GlobalVariableSet("PERMISSION", TimeCurrent());
      if (!SupportECN) {
         if (Ai_0) {
            if (OrderSelect(Gi_400, SELECT_BY_TICKET)) Ld_16 = OrderTakeProfit() + MarketInfo(Symbol(), MODE_SPREAD) * Point;
         } else Ld_8 = Bid - Gd_132 * Point;
      }
      if (Ai_0) Ls_24 = Gs__hedged_408;
      if (AllowiStopLoss == TRUE) Ld_16 = Bid + Gi_144 * Point;
      if (Ai_0) Ld_36 = NormalizeDouble(f0_7(0) * MassHedgeBooster, 2);
      else Ld_36 = f0_2(Gd_244);
      if (!SupportECN) Li_4 = OrderSend(Symbol(), OP_SELL, Ld_36, Bid, slippage, Ld_16, Ld_8, EA_Name + Ls_24, MagicNumber, 0, Pink);
      else {
         Li_4 = OrderSend(Symbol(), OP_SELL, Ld_36, Bid, slippage, 0, 0, EA_Name + Ls_24, MagicNumber, 0, Pink);
         Sleep(1000);
         OrderModify(Li_4, OrderOpenPrice(), Ld_16, Ld_8, 0, Black);
      }
      Gi_324 = TimeCurrent();
      if (Li_4 != -1) {
         if (!Ai_0) {
            Gi_400 = Li_4;
            f0_13("SELL hedgedTicket=" + Gi_400);
         } else {
            f0_13("SELL Hacked_ticket=" + Li_4);
            Gi_404 = 1;
         }
      } else {
         f0_13("failed sell");
         Li_32 = FALSE;
      }
   }
   GlobalVariableDel("PERMISSION");
   return (Li_32);
}

// CCB1059879745CEF2FE100D422C58CC5
void f0_12() {
   int Li_0 = 0;
   double Ld_4 = 0;
   double Ld_12 = 0;
   double Ld_20 = 0;
   int Li_28 = -1;
   int Li_32 = 0;
   int Li_36 = 0;
   int Li_40 = 0;
   for (Li_36 = 0; Li_36 < OrdersTotal(); Li_36++) {
      if (OrderSelect(Li_36, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
            Li_40++;
            if (OrderOpenTime() > Li_0) {
               Li_0 = OrderOpenTime();
               Ld_4 = OrderOpenPrice();
               Li_28 = OrderType();
               Li_32 = OrderTicket();
               Ld_20 = OrderTakeProfit();
            }
            if (OrderLots() > Ld_12) Ld_12 = OrderLots();
         }
      }
   }
   int Li_44 = MathRound(MathLog(Ld_12 / Lots) / MathLog(Booster)) + 1.0;
   if (Li_44 < 0) Li_44 = 0;
   Gd_244 = NormalizeDouble(Lots * MathPow(Booster, Li_44), Gi_336);
   if (Li_44 == 0 && f0_5() == 1 && f0_9()) {
      if (f0_8())
         if (MassHedge) Gi_384 = TRUE;
   } else {
      if (Ld_4 - Ask > PipStarter * Gd_328 && Ld_4 > 0.0 && Li_40 < MaxBuyOrders) {
         if (!(f0_8())) return;
         if (!(MassHedge)) return;
         Gi_384 = TRUE;
         return;
      }
   }
   for (Li_36 = 0; Li_36 < OrdersTotal(); Li_36++) {
      OrderSelect(Li_36, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != MagicNumber || OrderType() != OP_BUY || OrderTakeProfit() == Ld_20 || Ld_20 == 0.0) continue;
      OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), Ld_20, 0, Pink);
      Sleep(1000);
   }
}

// 5CB0F7C7F8EC494C325A7BDABDBF8656
int f0_5() {
   double Ld_0 = iSAR(NULL, 0, Gd_280, Gd_288, 0);
   double Ld_8 = iMA(NULL, 0, Gi_264, Gi_268, Gi_272, Gi_276, 0);
   if (Ld_0 > Ld_8) return (-1);
   if (Ld_0 < Ld_8) return (1);
   return (0);
}

// B69C187B5B28537387FD39F3050D06F5
void f0_11() {
   int Li_0 = 0;
   double Ld_4 = 0;
   double Ld_12 = 0;
   double Ld_20 = 0;
   int Li_28 = -1;
   int Li_32 = 0;
   int Li_36 = 0;
   int Li_40 = 0;
   for (Li_36 = 0; Li_36 < OrdersTotal(); Li_36++) {
      if (OrderSelect(Li_36, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
            Li_40++;
            if (OrderOpenTime() > Li_0) {
               Li_0 = OrderOpenTime();
               Ld_4 = OrderOpenPrice();
               Li_28 = OrderType();
               Li_32 = OrderTicket();
               Ld_20 = OrderTakeProfit();
            }
            if (OrderLots() > Ld_12) Ld_12 = OrderLots();
         }
      }
   }
   int Li_44 = MathRound(MathLog(Ld_12 / Lots) / MathLog(Booster)) + 1.0;
   if (Li_44 < 0) Li_44 = 0;
   Gd_244 = NormalizeDouble(Lots * MathPow(Booster, Li_44), Gi_336);
   if (Li_44 == 0 && f0_5() == -1 && f0_9()) {
      if (f0_10())
         if (MassHedge) Gi_388 = TRUE;
   } else {
      if (Bid - Ld_4 > PipStarter * Gd_328 && Ld_4 > 0.0 && Li_40 < MaxSellOrders) {
         if (!(f0_10())) return;
         if (!(MassHedge)) return;
         Gi_388 = TRUE;
         return;
      }
   }
   for (Li_36 = 0; Li_36 < OrdersTotal(); Li_36++) {
      if (OrderSelect(Li_36, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
            if (OrderTakeProfit() == Ld_20 || Ld_20 == 0.0) continue;
            OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), Ld_20, 0, Pink);
         }
      }
   }
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_20;
   double Ld_28;
   double Ld_36;
   if (Gs_376 != "approved") {
      Comment("Access denied!", 
         "\nMake you inputed your correct ForexHacked.com username into the EA paramaters", 
      "\nMake sure you login to http://www.ForexHacked.com/membership/login.php and input your forex account number in your profile settings");
      return (0);
   }
   if (allowTrending) {
      for (int Li_0 = 0; Li_0 < OrdersTotal(); Li_0++) {
         if (OrderSelect(Li_0, SELECT_BY_POS)) {
            if (MagicNumber == OrderMagicNumber()) {
               if (OrderType() == OP_BUY)
                  if (OrderTakeProfit() - Bid <= trendTrigger * Point && Bid < OrderTakeProfit()) OrderModify(OrderTicket(), 0, Bid - trendStoploss * Point, OrderTakeProfit() + trendPips * Point, 0, White);
               if (OrderType() == OP_SELL)
                  if (Ask - OrderTakeProfit() <= trendTrigger * Point && Ask > OrderTakeProfit()) OrderModify(OrderTicket(), 0, Ask + trendStoploss * Point, OrderTakeProfit() - trendPips * Point, 0, White);
            }
         }
      }
   }
   int Li_4 = 0;
   int Li_8 = 0;
   for (int Li_12 = 0; Li_12 < OrdersTotal(); Li_12++) {
      if (OrderSelect(Li_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber) {
            if (StringFind(OrderComment(), Gs__hedged_408) == -1) {
               if (OrderType() == OP_BUY) {
                  Li_4++;
                  continue;
               }
               if (OrderType() == OP_SELL) Li_8++;
            }
         }
      }
   }
   if (Li_4 >= TradesDeep) {
      if (!Gi_396) {
         f0_13("Allow long hedge! trades=" + Li_4 + ",TradesDeep=" + TradesDeep);
         Gi_396 = TRUE;
      }
   }
   if (Li_8 >= TradesDeep) {
      if (!Gi_392) {
         f0_13("Allow short hedge! trades=" + Li_8 + ",TradesDeep=" + TradesDeep);
         Gi_392 = TRUE;
      }
   }
   bool Li_16 = FALSE;
   if ((100 - StopLossPct) * AccountBalance() / 100.0 >= AccountEquity()) {
      f0_13("AccountBalance=" + AccountBalance() + ",AccountEquity=" + AccountEquity());
      Gi_260 = TRUE;
      Li_16 = TRUE;
   }
   if ((TakeProfitPct + 100.0) * AccountBalance() / 100.0 <= AccountEquity()) Gi_260 = TRUE;
   if (Gi_260) {
      for (Li_0 = OrdersTotal() - 1; Li_0 >= 0; Li_0--) {
         if (OrderSelect(Li_0, SELECT_BY_POS)) {
            if (OrderMagicNumber() == MagicNumber) {
               f0_13("close #" + OrderTicket());
               if (!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), MarketInfo(Symbol(), MODE_SPREAD), White)) {
                  f0_13("error");
                  return (0);
               }
            }
         }
      }
      Gi_260 = FALSE;
      if (Li_16) {
         Sleep(1000 * StoppedOutPause);
         Li_16 = FALSE;
      }
      Gi_396 = FALSE;
      Gi_392 = FALSE;
   }
   if (SupportECN) {
      Ld_20 = 0;
      if (OrderSelect(Gi_400, SELECT_BY_TICKET)) Ld_20 = OrderTakeProfit();
      for (Li_0 = 0; Li_0 < OrdersTotal(); Li_0++) {
         if (OrderSelect(Li_0, SELECT_BY_POS)) {
            if (OrderMagicNumber() == MagicNumber) {
               if (OrderTakeProfit() == 0.0 && StringFind(OrderComment(), Gs__hedged_408) == -1) {
                  if (OrderType() == OP_BUY) {
                     OrderModify(OrderTicket(), 0, OrderStopLoss(), OrderOpenPrice() + Gd_132 * Point, 0, White);
                     continue;
                  }
                  if (OrderType() != OP_SELL) continue;
                  OrderModify(OrderTicket(), 0, OrderStopLoss(), OrderOpenPrice() - Gd_132 * Point, 0, White);
                  continue;
               }
               if (StringFind(OrderComment(), Gs__hedged_408) != -1 && Gi_404 == OrderType()) {
                  Ld_28 = Ld_20 - MarketInfo(Symbol(), MODE_SPREAD) * Point;
                  Ld_36 = Ld_20 + MarketInfo(Symbol(), MODE_SPREAD) * Point;
                  if (OrderStopLoss() == 0.0 || (OrderType() == OP_BUY && OrderStopLoss() != Ld_28) || (OrderType() == OP_SELL && OrderStopLoss() != Ld_36)) {
                     if (OrderType() == OP_BUY) {
                        OrderModify(OrderTicket(), 0, Ld_28, OrderTakeProfit(), 0, White);
                        continue;
                     }
                     if (OrderType() == OP_SELL) OrderModify(OrderTicket(), 0, Ld_36, OrderTakeProfit(), 0, White);
                  }
               }
            }
         }
      }
   }
   if (f0_0() != 0) {
      f0_12();
      f0_11();
      if ((!PauseNewTrades) && f0_9()) {
         if (Gi_388)
            if (f0_8(1)) Gi_388 = FALSE;
         if (Gi_384)
            if (f0_10(1)) Gi_384 = FALSE;
      }
      f0_14();
      return (0);
   }
   return (0);
}

// E2E55FE76D835B9574F0F0BBDE4389D4
void f0_14() {
   string Ls_0 = DoubleToStr(f0_1(2), 2);
   for (int Li_8 = 0; Li_8 < OrdersHistoryTotal(); Li_8++)
      if (OrderSelect(Li_8, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() <= OP_SELL) Gd_120 += OrderProfit() + OrderCommission() + OrderSwap();
   Comment(" \nForexHacked V2.5 Loaded Successfully?", 
      "\nAccount Leverage  :  " + "1 : " + AccountLeverage(), 
      "\nAccount Type  :  " + AccountServer(), 
      "\nServer Time  :  " + TimeToStr(TimeCurrent(), TIME_SECONDS), 
      "\nAccount Equity  = ", AccountEquity(), 
      "\nFree Margin     = ", AccountFreeMargin(), 
   "\nDrawdown  :  ", Ls_0, " \n" + Symbol(), " Earnings  :  " + Gd_120);
}

// 060BF2D587991D8F090A1309B285291C
int f0_0() {
   return (1);
}

// 0E1322D82872392ADED74DAACDDE6704
double f0_1(int Ai_0) {
   double Ld_4;
   if (Ai_0 == 2) {
      Ld_4 = (AccountEquity() / AccountBalance() - 1.0) / (-0.01);
      if (Ld_4 <= 0.0) return (0);
      return (Ld_4);
   }
   if (Ai_0 == 1) {
      Ld_4 = 100.0 * (AccountEquity() / AccountBalance() - 1.0);
      if (Ld_4 <= 0.0) return (0);
      return (Ld_4);
   }
   return (0.0);
}
