//+------------------------------------------------------------------+
//|                                    Ahmad samir Virtual Trade.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright ""
#property link      "" 

#property indicator_chart_window 
//#property indicator_buffers     1
//#property indicator_width1     2
//#property indicator_color1      Lime

extern double Lot = 0.1;
extern bool Show_Jump_Alert = false;
extern bool EmailEnabled = false;
//extern string ProfitPerLotAre = "Profit Every +1pips on Lot";

extern string Suffix = "-STD";
extern string SetForSell = "==Couples for SELL==";// Below the Pairs to Sell
extern string Pair_1st = "NZDJPY";
extern string Pair_2nd = "USDJPY";
extern string Pair_3rd = "GBPCHF";
extern string Pair_4th = "CHFJPY";
extern string Pair_5th = "AUDUSD";
extern string Pair_6th = "EURCHF";
extern string Pair_7th = "EURUSD";

extern string SetForBuy = "==Couples for BUY==";// Lower Pairs to Buy
extern string Pair_8th = "EURGBP";
extern string Pair_9th = "GBPUSD";
extern string Pair_10th = "USDCHF";
extern string Pair_11th = "NZDUSD";
extern string Pair_12th = "EURJPY";
extern string Pair_13th = "AUDJPY";
extern string Pair_14th = "GBPJPY";

extern string Comm1 = "Coordinates Placement on The Chart";
extern int Side = 1;
extern int MP_Y = 0; 
extern int MP_X = 50;

double profit_sum,buf[];

extern string Colors_Setting ="Colors";
extern color Title        = White;
extern color Head         = Wheat;
extern color SlotsSELL    = Red;
extern color SlotsBUY     = LimeGreen;
extern color Total        = LightGoldenrod;


color ColorSlots;

int init() {
    return (0);
}

int deinit() {

   Comment("");
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_1st, 1)); // Resets the Global Variable Pj - Slot BTS,erases all line
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_2nd, 2));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_3rd, 3));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_4th, 4));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_5th, 5));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_6th, 6));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_7th, 7));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_8th, 8));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_9th, 9));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_10th, 10));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_11th, 11));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_12th, 12));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_13th, 13));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair_14th, 14));
   
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       ObjectDelete(label);   
     }  
   return (0);
}
bool traded=false;
int start() {
   int l_ind_counted_0 = IndicatorCounted();//number of bars, not counted after the last call 
   double sellprofit=0, buyprofit=0;
   for(int i=0; i<=OrdersTotal(); i++)  {
      if(OrderSelect(i,SELECT_BY_POS)==true) {                                   
           if(OrderType()==OP_BUY) buyprofit=buyprofit+OrderProfit();
           if(OrderType()==OP_SELL) sellprofit=sellprofit+OrderProfit();
      }
   }
   Write("Orders", Side, MP_X+90, MP_Y+315, "Open orders", 10, "Impact", Total); 
   Write("OrdersBuy", Side, MP_X+90, MP_Y+330, "BUY : "+DoubleToStr(buyprofit,2), 10, "Verdana", Total);
   Write("OrdersSell", Side, MP_X+90, MP_Y+343, "SELL: "+DoubleToStr(sellprofit,2), 10, "Verdana", Total);
   Write("OrdersTotal", Side, MP_X+90, MP_Y+360, "Result: "+DoubleToStr(buyprofit+sellprofit,2), 10, "Verdana", Total);  
         
   Write("uTitle", Side, MP_X+1, MP_Y+15, "vSell: "+sumSELL()+"\t      vBuy: "+sumBUY(), 8, "Verdana", Title);         
   Write("Title", Side, MP_X+1, MP_Y+30, "Samir virtual trades (Universal Pairs)", 8, "Verdana", Title); 
   /*if(sum()>70 && TradeType(CheckPairRank(1))=="Buy") {Write("LONG", Side, MP_X+10, MP_Y+40, "LONG", 18, "Verdana", Red); ObjectDelete("SHORT"); ObjectDelete("NONE");}
     else if(sum()<-70 && TradeType(CheckPairRank(1))=="Sell") {Write("SHORT", Side, MP_X+10, MP_Y+40, "SHORT", 18, "Verdana", Blue); ObjectDelete("LONG"); ObjectDelete("NONE");}
            else {Write("NONE", Side, MP_X+10, MP_Y+40, "NONE", 18, "Verdana", Title); ObjectDelete("SHORT"); ObjectDelete("LONG");}
   */
   Write("NONE", Side, MP_X+10, MP_Y+40, "NONE", 18, "Verdana", Total); 
   ObjectDelete("LONG WEAK"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("LONG STRONG");
   if(sumSELL()<0 && sumBUY()>0) {Write("LONG STRONG", Side, MP_X+10, MP_Y+40, "LONG STRONG", 18, "Verdana", Red); 
      ObjectDelete("LONG WEAK"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");}
   if(sumSELL()>0 && sumBUY()>0 && sumBUY()>sumSELL()) {traded=false; Write("LONG WEAK", Side, MP_X+10, MP_Y+40, "LONG WEAK", 18, "Verdana", Red); 
      ObjectDelete("LONG STRONG"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");}      
   if(sumSELL()>0 && sumBUY()<0) {Write("SHORT STRONG", Side, MP_X+10, MP_Y+40, "SHORT STRONG", 18, "Verdana", Blue); 
      ObjectDelete("LONG WEAK"); ObjectDelete("LONG STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");} 
   if(sumSELL()>0 && sumBUY()>0 && sumBUY()<sumSELL()) {traded=false; Write("SHORT WEAK", Side, MP_X+10, MP_Y+40, "SHORT WEAK", 18, "Verdana", Blue); 
      ObjectDelete("LONG WEAK"); ObjectDelete("LONG STRONG"); ObjectDelete("SHORT STRONG"); ObjectDelete("NONE");}        
   
   Write("Head", Side, MP_X+10, MP_Y+70, "No. B/S   Pairs       Profit", 10, "Arial Narrow", Total); 
   
   if(TradeType(CheckPairRank(1))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("1", Side, MP_X+180, MP_Y+90, "1:  ", 11, "Verdana", ColorSlots);
   Write("1T", Side, MP_X+155, MP_Y+90, TradeType(CheckPairRank(1)), 11, "Verdana", ColorSlots);
   Write("1O", Side, MP_X+85, MP_Y+90, CheckPairRank(1), 11, "Verdana", ColorSlots);
   Write("1P", Side, MP_X+1, MP_Y+90, DoubleToStr(CheckPairProfit(CheckPairRank(1)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(2))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("2", Side, MP_X+180, MP_Y+105, "2:  ", 11, "Verdana", ColorSlots);
   Write("2T", Side, MP_X+155, MP_Y+105, TradeType(CheckPairRank(2)), 11, "Verdana", ColorSlots);
   Write("2O", Side, MP_X+85, MP_Y+105, CheckPairRank(2), 11, "Verdana", ColorSlots);
   Write("2P", Side, MP_X+1, MP_Y+105, DoubleToStr(CheckPairProfit(CheckPairRank(2)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(3))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("3", Side, MP_X+180, MP_Y+120, "3:  ", 11, "Verdana", ColorSlots);
   Write("3T", Side, MP_X+155, MP_Y+120, TradeType(CheckPairRank(3)), 11, "Verdana", ColorSlots);
   Write("3O", Side, MP_X+85, MP_Y+120, CheckPairRank(3), 11, "Verdana", ColorSlots);
   Write("3P", Side, MP_X+1, MP_Y+120, DoubleToStr(CheckPairProfit(CheckPairRank(3)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(4))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("4", Side, MP_X+180, MP_Y+135, "4:  ", 11, "Verdana", ColorSlots);
   Write("4T", Side, MP_X+155, MP_Y+135, TradeType(CheckPairRank(4)), 11, "Verdana", ColorSlots);
   Write("4O", Side, MP_X+85, MP_Y+135, CheckPairRank(4), 11, "Verdana", ColorSlots);
   Write("4P", Side, MP_X+1, MP_Y+135, DoubleToStr(CheckPairProfit(CheckPairRank(4)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(5))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("5", Side, MP_X+180, MP_Y+150, "5:  ", 11, "Verdana", ColorSlots);
   Write("5T", Side, MP_X+155, MP_Y+150, TradeType(CheckPairRank(5)), 11, "Verdana", ColorSlots);
   Write("5O", Side, MP_X+85, MP_Y+150, CheckPairRank(5), 11, "Verdana", ColorSlots);
   Write("5P", Side, MP_X+1, MP_Y+150, DoubleToStr(CheckPairProfit(CheckPairRank(5)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(6))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("6", Side, MP_X+180, MP_Y+165, "6:  ", 11, "Verdana", ColorSlots);
   Write("6T", Side, MP_X+155, MP_Y+165, TradeType(CheckPairRank(6)), 11, "Verdana", ColorSlots);
   Write("6O", Side, MP_X+85, MP_Y+165, CheckPairRank(6), 11, "Verdana", ColorSlots);
   Write("6P", Side, MP_X+1, MP_Y+165, DoubleToStr(CheckPairProfit(CheckPairRank(6)),2), 11, "Verdana", ColorSlots);
      
   if(TradeType(CheckPairRank(7))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("7", Side, MP_X+180, MP_Y+180, "7:  ", 11, "Verdana", ColorSlots);
   Write("7T", Side, MP_X+155, MP_Y+180, TradeType(CheckPairRank(7)), 11, "Verdana", ColorSlots);
   Write("7O", Side, MP_X+85, MP_Y+180, CheckPairRank(7), 11, "Verdana", ColorSlots);
   Write("7P", Side, MP_X+1, MP_Y+180, DoubleToStr(CheckPairProfit(CheckPairRank(7)),2), 11, "Verdana", ColorSlots);
   
   Write("==", Side, MP_X+1, MP_Y+193, "==========================", 12, "Arial Narrow", Total);
   
   if(TradeType(CheckPairRank(8))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("8", Side, MP_X+180, MP_Y+205, "8:  ", 11, "Verdana", ColorSlots);
   Write("8T", Side, MP_X+155, MP_Y+205, TradeType(CheckPairRank(8)), 11, "Verdana", ColorSlots);
   Write("8O", Side, MP_X+85, MP_Y+205, CheckPairRank(8), 11, "Verdana", ColorSlots);
   Write("8P", Side, MP_X+1, MP_Y+205, DoubleToStr(CheckPairProfit(CheckPairRank(8)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(9))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("9", Side, MP_X+180, MP_Y+220, "9:  ", 11, "Verdana", ColorSlots);
   Write("9T", Side, MP_X+155, MP_Y+220, TradeType(CheckPairRank(9)), 11, "Verdana", ColorSlots);
   Write("9O", Side, MP_X+85, MP_Y+220, CheckPairRank(9), 11, "Verdana", ColorSlots);
   Write("9P", Side, MP_X+1, MP_Y+220, DoubleToStr(CheckPairProfit(CheckPairRank(9)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(10))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("10", Side, MP_X+180, MP_Y+235, "10:  ", 11, "Verdana", ColorSlots);
   Write("10T", Side, MP_X+155, MP_Y+235, TradeType(CheckPairRank(10)), 11, "Verdana", ColorSlots);
   Write("10O", Side, MP_X+85, MP_Y+235, CheckPairRank(10), 11, "Verdana", ColorSlots);
   Write("10P", Side, MP_X+1, MP_Y+235, DoubleToStr(CheckPairProfit(CheckPairRank(10)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(11))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("11", Side, MP_X+180, MP_Y+250, "11:  ", 11, "Verdana", ColorSlots);
   Write("11T", Side, MP_X+155, MP_Y+250, TradeType(CheckPairRank(11)), 11, "Verdana", ColorSlots);
   Write("11O", Side, MP_X+85, MP_Y+250, CheckPairRank(11), 11, "Verdana", ColorSlots);
   Write("11P", Side, MP_X+1, MP_Y+250, DoubleToStr(CheckPairProfit(CheckPairRank(11)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(12))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("12", Side, MP_X+180, MP_Y+265, "12:  ", 11, "Verdana", ColorSlots);
   Write("12T", Side, MP_X+155, MP_Y+265, TradeType(CheckPairRank(12)), 11, "Verdana", ColorSlots);
   Write("12O", Side, MP_X+85, MP_Y+265, CheckPairRank(12), 11, "Verdana", ColorSlots);
   Write("12P", Side, MP_X+1, MP_Y+265, DoubleToStr(CheckPairProfit(CheckPairRank(12)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(13))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("13", Side, MP_X+180, MP_Y+280, "13:  ", 11, "Verdana", ColorSlots);
   Write("13T", Side, MP_X+155, MP_Y+280, TradeType(CheckPairRank(13)), 11, "Verdana", ColorSlots);
   Write("13O", Side, MP_X+85, MP_Y+280, CheckPairRank(13), 11, "Verdana", ColorSlots);
   Write("13P", Side, MP_X+1, MP_Y+280, DoubleToStr(CheckPairProfit(CheckPairRank(13)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(14))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("14", Side, MP_X+180, MP_Y+295, "14:  ", 11, "Verdana", ColorSlots);
   Write("14T", Side, MP_X+155, MP_Y+295, TradeType(CheckPairRank(14)), 11, "Verdana", ColorSlots);
   Write("14O", Side, MP_X+85, MP_Y+295, CheckPairRank(14), 11, "Verdana", ColorSlots);
   Write("14P", Side, MP_X+1, MP_Y+295, DoubleToStr(CheckPairProfit(CheckPairRank(14)),2), 11, "Verdana", ColorSlots);
   
   Write("===", Side, MP_X+1, MP_Y+300, "_____________________", 12, "Verdana", Total);
   Write("Sum", Side, MP_X+1, MP_Y+320, DoubleToStr(sum(),2), 18, "Impact", Total);
      
   
   if (Show_Jump_Alert) {
      RankChangeAlert(Pair_1st, 1);
      RankChangeAlert(Pair_2nd, 2);
      RankChangeAlert(Pair_3rd, 3);
      RankChangeAlert(Pair_4th, 4);
      RankChangeAlert(Pair_5th, 5);
      RankChangeAlert(Pair_6th, 6);
      RankChangeAlert(Pair_7th, 7);
      RankChangeAlert(Pair_8th, 8);
      RankChangeAlert(Pair_9th, 9);
      RankChangeAlert(Pair_10th, 10);
      RankChangeAlert(Pair_11th, 11);
      RankChangeAlert(Pair_12th, 12);
      RankChangeAlert(Pair_13th, 13);
      RankChangeAlert(Pair_14th, 14);
   }
   if (sumSELL()<0 && sumBUY()>0 && traded==false)
      {traded=true; WindowScreenShot("shots\\"+TimeToStr(TimeCurrent(),TIME_DATE)+"."+Hour()+Minute()+Seconds()+".gif",640,480);
      if(EmailEnabled)SendMail("Long Strong","Check Charts");
      }
   if (sumSELL()>0 && sumBUY()<0 && traded==false)
      {traded=true; WindowScreenShot("shots\\"+TimeToStr(TimeCurrent(),TIME_DATE)+"."+Hour()+Minute()+Seconds()+".gif",640,480);
      if(EmailEnabled)SendMail("Short Strong","Check Charts");
      }
buf[0]=sum(); 
   return (0);
}

double OpenWeek(string pair_symbol, int pair_index) {// considers the opening of the week, bais adds to spread
   double open_week;
   if (pair_index < 8) open_week = iOpen(pair_symbol, PERIOD_W1, 0);
   else open_week = iOpen(pair_symbol, PERIOD_W1, 0);// + MarketInfo(pair_symbol, MODE_SPREAD) * MarketInfo(pair_symbol, MODE_POINT);
   return (open_week);
}

double ProfitPair(int pair_index) {
   string pair_symbol;
   double ld_12;
   if (pair_index == 1) pair_symbol = Pair_1st;
   if (pair_index == 2) pair_symbol = Pair_2nd;
   if (pair_index == 3) pair_symbol = Pair_3rd;
   if (pair_index == 4) pair_symbol = Pair_4th;
   if (pair_index == 5) pair_symbol = Pair_5th;
   if (pair_index == 6) pair_symbol = Pair_6th;
   if (pair_index == 7) pair_symbol = Pair_7th;
   if (pair_index == 8) pair_symbol = Pair_8th;
   if (pair_index == 9) pair_symbol = Pair_9th;
   if (pair_index == 10) pair_symbol = Pair_10th;
   if (pair_index == 11) pair_symbol = Pair_11th;
   if (pair_index == 12) pair_symbol = Pair_12th;
   if (pair_index == 13) pair_symbol = Pair_13th;
   if (pair_index == 14) pair_symbol = Pair_14th;
   pair_symbol = pair_symbol+Suffix;
   double ld_20 = MarketInfo(pair_symbol, MODE_TICKVALUE) / MarketInfo(pair_symbol, MODE_TICKSIZE) * MarketInfo(pair_symbol, MODE_POINT);// calculates the value of the item pairs in the U.S
   RefreshRates();// updates the value of tick
   if (pair_index < 8) ld_12 = (OpenWeek(pair_symbol, pair_index) - MarketInfo(pair_symbol, MODE_ASK)) / MarketInfo(pair_symbol, MODE_POINT) * ld_20;// for the opening week of the village ASK ASK minus pair 
   else ld_12 = (MarketInfo(pair_symbol, MODE_BID) - OpenWeek(pair_symbol, pair_index)) / MarketInfo(pair_symbol, MODE_POINT) * ld_20;// bai bid for a pair of minus bid beginning of the week
   return (NormalizeDouble(ld_12 * Lot, 2));// multiplies the difference between the opening weeks of dollar value of the lot
}

string CheckPairRank(int pair_index) {
   if (pair_index == Rank(1)) return (Pair_1st);
   if (pair_index == Rank(2)) return (Pair_2nd);
   if (pair_index == Rank(3)) return (Pair_3rd);
   if (pair_index == Rank(4)) return (Pair_4th);
   if (pair_index == Rank(5)) return (Pair_5th);
   if (pair_index == Rank(6)) return (Pair_6th);
   if (pair_index == Rank(7)) return (Pair_7th);
   if (pair_index == Rank(8)) return (Pair_8th);
   if (pair_index == Rank(9)) return (Pair_9th);
   if (pair_index == Rank(10)) return (Pair_10th);
   if (pair_index == Rank(11)) return (Pair_11th);
   if (pair_index == Rank(12)) return (Pair_12th);
   if (pair_index == Rank(13)) return (Pair_13th);
   if (pair_index == Rank(14)) return (Pair_14th);
   return ("");
}

double CheckPairProfit(string pair_symbol) {
   if (pair_symbol == Pair_1st) return (ProfitPair(1));
   if (pair_symbol == Pair_2nd) return (ProfitPair(2));
   if (pair_symbol == Pair_3rd) return (ProfitPair(3));
   if (pair_symbol == Pair_4th) return (ProfitPair(4));
   if (pair_symbol == Pair_5th) return (ProfitPair(5));
   if (pair_symbol == Pair_6th) return (ProfitPair(6));
   if (pair_symbol == Pair_7th) return (ProfitPair(7));
   if (pair_symbol == Pair_8th) return (ProfitPair(8));
   if (pair_symbol == Pair_9th) return (ProfitPair(9));
   if (pair_symbol == Pair_10th) return (ProfitPair(10));
   if (pair_symbol == Pair_11th) return (ProfitPair(11));
   if (pair_symbol == Pair_12th) return (ProfitPair(12));
   if (pair_symbol == Pair_13th) return (ProfitPair(13));
   if (pair_symbol == Pair_14th) return (ProfitPair(14));
   return (0.0);
}
double sum()
{
double tmp=0;
for (int j=1; j<15; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}

int Rank(int pair_index) {
   double lda_4[15];
   for (int i = 14; i > 0; i--) lda_4[i] = ProfitPair(i); 
   ArraySort(lda_4, WHOLE_ARRAY, 1, MODE_ASCEND);
   int li_12 = ArrayBsearch(lda_4, ProfitPair(pair_index), WHOLE_ARRAY, 1);
   return (15 - li_12);
}

string TradeType(string pair_symbol) {
   if (pair_symbol == Pair_1st) return ("Sell");
   if (pair_symbol == Pair_2nd) return ("Sell");
   if (pair_symbol == Pair_3rd) return ("Sell");
   if (pair_symbol == Pair_4th) return ("Sell");
   if (pair_symbol == Pair_5th) return ("Sell");
   if (pair_symbol == Pair_6th) return ("Sell");
   if (pair_symbol == Pair_7th) return ("Sell");
   if (pair_symbol == Pair_8th) return ("Buy");
   if (pair_symbol == Pair_9th) return ("Buy");
   if (pair_symbol == Pair_10th) return ("Buy");
   if (pair_symbol == Pair_11th) return ("Buy");
   if (pair_symbol == Pair_12th) return ("Buy");
   if (pair_symbol == Pair_13th) return ("Buy");
   if (pair_symbol == Pair_14th) return ("Buy");
   return ("");
}

void RankChangeAlert(string pair_symbol, int pair_index) {
   if (!GlobalVariableCheck(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index))) GlobalVariableSet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index), Rank(pair_index));
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index)) <= 7.0) {
      if (Rank(pair_index) > 7) {
         Alert("Passed ", pair_symbol, " with slots ", GlobalVariableGet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index)), " per slot ", Rank(pair_index), "");
         GlobalVariableSet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index), Rank(pair_index));
      }
   }
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index)) >= 8.0) {
      if (Rank(pair_index) < 8) {
         Alert("Passed ", pair_symbol, " with slots ", GlobalVariableGet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index)), " per slot ", Rank(pair_index), "");
         GlobalVariableSet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index), Rank(pair_index));
      }
   }
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index)) != Rank(pair_index)) GlobalVariableSet(StringConcatenate("Pj - Slot BTS", pair_symbol, pair_index), Rank(pair_index));
}

void Write(string LBL, double side, int pos_x, int pos_y, string text, int fontsize, string fontname, color Tcolor=CLR_NONE)
     {
       ObjectCreate(LBL, OBJ_LABEL, 0, 0, 0);
       ObjectSetText(LBL,text, fontsize, fontname, Tcolor);
       ObjectSet(LBL, OBJPROP_CORNER, side);
       ObjectSet(LBL, OBJPROP_XDISTANCE, pos_x);
       ObjectSet(LBL, OBJPROP_YDISTANCE, pos_y);
     }
     
double sumSELL()
{
double tmp=0;
for (int j=1; j<8; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}

double sumBUY()
{
double tmp=0;
for (int j=8; j<15; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}     