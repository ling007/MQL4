 
#property copyright "Expforex.at.ua"
#property link      "Expforex.at.ua"

extern string strcom="ACT";
extern int Magic=2017;
extern double TakeProfit = 11.0;
extern double Lots = 0.01;
extern double InitialStop = 0.0;
extern double TrailingStop = 15.0;
extern int MaxTrades = 6;
extern int Pips = 8;
extern int SecureProfit = 10;
extern int AccountProtection = 1;
extern int OrderstoProtect = 3;
extern int ReverseCondition = 0;
extern double USDJPYPipValue = 9.715;
extern int StartYear = 2017;
extern int StartMonth = 1;
extern int EndYear = 2022;
extern int EndMonth = 12;
extern int EndHour = 22;
extern int EndMinute = 30;
extern int mm = 0;
extern int risk = 12;
extern int AccountisNormal = 0;
int g_count_176 = 0;
int g_pos_180 = 0;
int g_slippage_184 = 5;
double g_price_188 = 0.0;
double g_price_196 = 0.0;
double g_ask_204 = 0.0;
double g_bid_212 = 0.0;
double gd_220 = 0.0;
double g_lots_228 = 0.0;
int g_cmd_236 = OP_BUY;
int gi_240 = 0;
bool gi_244 = TRUE;
double g_ord_open_price_248 = 0.0;
int gi_256 = 0;
double gd_260 = 0.0;
int g_ticket_268 = 0;
int gi_272 = 0;
double g_price_276 = 0.0;
double g_ord_lots_284 = 0.0;
double gd_unused_292 = 0.0;
double gd_300 = 0.0;
string gs_308 = "";
string gs_316 = "";
 

double setpoint() {
   double ld_ret_0;
   if (Digits <= 3) ld_ret_0 = 0.01;
   else ld_ret_0 = 0.0001;
   return (ld_ret_0);
}

int init() {
   return (0);
}

int deinit() {
   return (0);
}

int start() {
 
   if (AccountisNormal == 1) {
      if (mm != 0) gd_220 = MathCeil(AccountBalance() * risk / 2500.0);
      else gd_220 = Lots;
   } else {
      if (mm != 0) gd_220 = MathCeil(AccountBalance() * risk / 2500.0) / 10.0;
      else gd_220 = Lots;
   }
   if (gd_220 > 100.0) gd_220 = 100;
   g_count_176 = 0;
   for (g_pos_180 = 0; g_pos_180 < OrdersTotal(); g_pos_180++) {
      OrderSelect(g_pos_180, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==Magic) g_count_176++;
   }
   if (g_count_176 < 1) {
      if (TimeYear(TimeCurrent()) < StartYear) return (0);
      if (TimeMonth(TimeCurrent()) < StartMonth) return (0);
      if (TimeYear(TimeCurrent()) > EndYear) return (0);
      if (TimeMonth(TimeCurrent()) > EndMonth) return (0);
   }
   if (Symbol() == "USDJPY-STD") gd_300 = USDJPYPipValue;
   if (gd_300 == 0.0) gd_300 = 5;
   if (gi_256 > g_count_176) {
      for (g_pos_180 = OrdersTotal(); g_pos_180 >= 0; g_pos_180--) {
         OrderSelect(g_pos_180, SELECT_BY_POS, MODE_TRADES);
         g_cmd_236 = OrderType();
         if (OrderSymbol() == Symbol() && OrderMagicNumber()==Magic) {
            if (g_cmd_236 == OP_BUY ) OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), g_slippage_184, Blue);
            if (g_cmd_236 == OP_SELL ) OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), g_slippage_184, Red);
            return (0);
         }
      }
   }
   gi_256 = g_count_176;
   if (g_count_176 >= MaxTrades) gi_244 = FALSE;
   else gi_244 = TRUE;
   if (g_ord_open_price_248 == 0.0) {
      for (g_pos_180 = 0; g_pos_180 < OrdersTotal(); g_pos_180++) {
         OrderSelect(g_pos_180, SELECT_BY_POS, MODE_TRADES);
         g_cmd_236 = OrderType();
         if (OrderSymbol() == Symbol() && OrderMagicNumber()==Magic) {
            g_ord_open_price_248 = OrderOpenPrice();
            if (g_cmd_236 == OP_BUY) gi_240 = 2;
            if (g_cmd_236 == OP_SELL) gi_240 = 1;
         }
      }
   }
   if (g_count_176 < 1) {
      gi_240 = 3;
      if (iMACD(NULL, 0, 8, 12, 6, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 8, 12, 6, PRICE_CLOSE, MODE_MAIN, 1)) gi_240 = 2;
      if (iMACD(NULL, 0, 8, 12, 6, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 8, 12, 6, PRICE_CLOSE, MODE_MAIN, 1)) gi_240 = 1;
      if (ReverseCondition == 1) {
         if (gi_240 == 1) gi_240 = 2;
         else
            if (gi_240 == 2) gi_240 = 1;
      }
   }
   for (g_pos_180 = OrdersTotal(); g_pos_180 >= 0; g_pos_180--) {
      OrderSelect(g_pos_180, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==Magic) {
         if (OrderType() == OP_SELL) {
            if (TrailingStop > 0.0) {
               if (OrderOpenPrice() - Ask >= (TrailingStop + Pips) * setpoint()) {
                  if (OrderStopLoss() > Ask + setpoint() * TrailingStop) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Ask + setpoint() * TrailingStop, OrderClosePrice() - TakeProfit * setpoint() - TrailingStop * setpoint(), 800, Purple);
                     return (0);
                  }
               }
            }
         }
         if (OrderType() == OP_BUY) {
            if (TrailingStop > 0.0) {
               if (Bid - OrderOpenPrice() >= (TrailingStop + Pips) * setpoint()) {
                  if (OrderStopLoss() < Bid - setpoint() * TrailingStop) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Bid - setpoint() * TrailingStop, OrderClosePrice() + TakeProfit * setpoint() + TrailingStop * setpoint(), 800, Yellow);
                     return (0);
                  }
               }
            }
         }
      }
   }
   gd_260 = 0;
   g_ticket_268 = 0;
   gi_272 = FALSE;
   g_price_276 = 0;
   g_ord_lots_284 = 0;
   for (g_pos_180 = 0; g_pos_180 < OrdersTotal(); g_pos_180++) {
      OrderSelect(g_pos_180, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber()==Magic) {
         g_ticket_268 = OrderTicket();
         if (OrderType() == OP_BUY) gi_272 = FALSE;
         if (OrderType() == OP_SELL) gi_272 = TRUE;
         g_price_276 = OrderClosePrice();
         g_ord_lots_284 = OrderLots();
         if (gi_272 == FALSE) {
            if (OrderClosePrice() < OrderOpenPrice()) gd_260 -= (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / setpoint();
            if (OrderClosePrice() > OrderOpenPrice()) gd_260 += (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / setpoint();
         }
         if (gi_272 == TRUE) {
            if (OrderClosePrice() > OrderOpenPrice()) gd_260 -= (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / setpoint();
            if (OrderClosePrice() < OrderOpenPrice()) gd_260 += (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / setpoint();
         }
      }
   }
   gd_260 *= gd_300;
   gs_316 = "Profit: $" + DoubleToStr(gd_260, 2) + " +/-";
   if (g_count_176 >= MaxTrades - OrderstoProtect && AccountProtection == 1) {
      if (gd_260 >= SecureProfit) {
         OrderClose(g_ticket_268, g_ord_lots_284, g_price_276, g_slippage_184, Yellow);
         gi_244 = FALSE;
         return (0);
      }
   }
   if (!IsTesting()) {
      if (gi_240 == 3) gs_308 = "No conditions to open trades";
      else gs_308 = "                         ";
      Comment("LastPrice=", g_ord_open_price_248, " Previous open orders=", gi_256, 
         "\nContinue opening=", gi_244, " OrderType=", gi_240, 
         "\n", gs_316, 
         "\nLots=", gd_220, 
      "\n", gs_308);
   }
   if (gi_240 == 1 && gi_244) {
      if (Bid - g_ord_open_price_248 >= Pips * setpoint() || g_count_176 < 1) {
         g_bid_212 = Bid;
         g_ord_open_price_248 = 0;
         if (TakeProfit == 0.0) g_price_196 = 0;
         else g_price_196 = g_bid_212 - TakeProfit * setpoint();
         if (InitialStop == 0.0) g_price_188 = 0;
         else g_price_188 = g_bid_212 + InitialStop * setpoint();
         if (g_count_176 != 0) {
            g_lots_228 = gd_220;
            for (g_pos_180 = 1; g_pos_180 <= g_count_176; g_pos_180++) {
               if (MaxTrades > 12) g_lots_228 = NormalizeDouble(1.5 * g_lots_228, 2);
               else g_lots_228 = NormalizeDouble(2.0 * g_lots_228, 2);
            }
         } else g_lots_228 = gd_220;
         if (g_lots_228 > 100.0) g_lots_228 = 100;
         OrderSend(Symbol(), OP_SELL, g_lots_228, g_bid_212, g_slippage_184, g_price_188, g_price_196, strcom, Magic, 0, Red);
         return (0);
      }
   }
   if (gi_240 == 2 && gi_244) {
      if (g_ord_open_price_248 - Ask >= Pips * setpoint() || g_count_176 < 1) {
         g_ask_204 = Ask;
         g_ord_open_price_248 = 0;
         if (TakeProfit == 0.0) g_price_196 = 0;
         else g_price_196 = g_ask_204 + TakeProfit * setpoint();
         if (InitialStop == 0.0) g_price_188 = 0;
         else g_price_188 = g_ask_204 - InitialStop * setpoint();
         if (g_count_176 != 0) {
            g_lots_228 = gd_220;
            for (g_pos_180 = 1; g_pos_180 <= g_count_176; g_pos_180++) {
               if (MaxTrades > 12) g_lots_228 = NormalizeDouble(1.5 * g_lots_228, 2);
               else g_lots_228 = NormalizeDouble(2.0 * g_lots_228, 2);
            }
         } else g_lots_228 = gd_220;
         if (g_lots_228 > 100.0) g_lots_228 = 100;
         OrderSend(Symbol(), OP_BUY, g_lots_228, g_ask_204, g_slippage_184, g_price_188, g_price_196, strcom, Magic, 0, Blue);
         return (0);
      }
   }
   return (0);
}