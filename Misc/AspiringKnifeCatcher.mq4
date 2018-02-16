//+------------------------------------------------------------------+
//|                                                  5MinScalper.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern double Min_Pip_Range_btwn_MAs = 10;
extern double Pip_Call_Range = 5;
extern int MA_big_period = 50; 
extern int MA_mid_period = 15;
extern int MA_small_period = 10;
extern int PastRange_bars = 10;
//extern double Lots = 1;
extern int StopLoss = 0;
extern int TakeProfit = 0;
extern bool UseKC = false;
extern double KCSize = 0.5;
extern int Magic = 3755;

int ticket = 0;
double Lots = 0.01;


void OnTick(){
   
   double MABig = MA(MA_big_period,0);
   double MAMid = MA(MA_mid_period,0);
   double MASmall = MA(MA_small_period,0);
   
   double range1 = MathAbs(MABig - MAMid);
   double range2 = MathAbs(MABig - MASmall);
   double range;
   
   if(range1 > range2){range = range2;} else{range = range1;}
   
   
   bool condA1 = false;//Distance from MABig condition
   bool condA2 = false;//Price below MA condition
   bool condA3 = false;//Price cross MAMid and MASmall toward MABig recently;
   bool condA4 = false;//Price cross MAMid and MASmall away from MABig more recently;
   
   if(range*10000 > Min_Pip_Range_btwn_MAs){
      condA1 = true;
   }
   
   //bool condB1 = false;//Price was outside all MAs as some point in past X bars (PastRange_bars)
   //bool condB2 = false;//Price was inside the mid and small MA toward the big MA by a range (pip_call_range) in the past X bars after condb1
   //bool condB3 = false;//Price currently is again on the outside of all MAs
   
   double low_price = 10; 
   double low_bar = 0; 
   double high_price = 0;
   double high_bar = 0;
      
   for(int i = 1; i <= PastRange_bars; i++){
      if(Open[i] < low_price){low_price = Open[i]; low_bar = i;}
      if(Open[i] > high_price){high_price = Open[i]; high_bar = i;}  
   }
   
   double KCWinPct = TakeProfit/StopLoss;
   //double KCSize = 1;
   //double Lots = 1;
   
   
   
   
   
   
   double RiskPct = KellyCriterion(KCWinPct, TakeProfit, StopLoss);
   double TradeSizeUSD = RiskPct * AccountBalance();
   
   if(UseKC == true){
      //if(Hour() == StartHour){printf(RiskPct);}
      double val = TradeSizeUSD/(2000*Ask)*KCSize;
      Lots = ((int)(val * 100 + 0.5)/100.0);
   }else if(UseKC == false){
      Lots = 1;
   }

   string comment = " ";
   bool result = false;
   
   if(condA1&&(low_bar > high_bar)&&(high_price < MA(MA_big_period,high_bar))&&(low_price < MA(MA_mid_period,low_bar))&&
     (low_price < MA(MA_small_period,low_bar))&&((high_price-Pip_Call_Range*Point) > MA(MA_mid_period,high_bar))&&
     ((high_price-Pip_Call_Range*Point) > MA(MA_small_period,high_bar))&&(Bid < MAMid)&&(Bid < MASmall)&&(CheckOpenOrders()==false)){
     //Sell!
     ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by 5MinScalper", Magic);
     if(ticket < 0){comment = comment + " " + "Error Sending SELL Order";}
     else{comment = comment + " " + "SELL Order Succesfuly Sent";}
     Alert("Sell Ticket # is: " + ticket);
   }
   
   
   
   if(condA1&&(high_bar > low_bar)&&(low_price > MA(MA_big_period,low_bar))&&(high_price > MA(MA_mid_period,high_bar))&&
     (high_price > MA(MA_small_period,high_bar))&&((low_price+Pip_Call_Range*Point) < MA(MA_mid_period,low_bar))&&
     ((low_price+Pip_Call_Range*Point) < MA(MA_small_period,low_bar))&&(Bid > MAMid)&&(Bid > MASmall)&&(CheckOpenOrders()==false)){
     //Buy!
     ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by 5MinScalper", Magic);
     if(ticket < 0){comment = comment + " " + "Error Sending BUY Order";}
     else{comment = comment + " " + "BUY Order Succesfuly Sent";}
     Alert("Buy Ticket # is: " + ticket);
   }
   

   
   if( OrdersTotal()!=0 && (Open[1]<MA(MA_big_period,1)&&Ask>MA(MA_big_period,0)) || (Open[1]>MA(MA_big_period,1)&&Bid<MA(MA_big_period,0)) ){
      
      /*OrderSelect(ticket, SELECT_BY_TICKET);
   
      if(OrderType() == OP_BUY){
         OrderClose(OrderTicket(), OrderLots(), Bid, 10, Blue);}
      else if(OrderType() == OP_SELL){
         OrderClose(OrderTicket(), OrderLots(), Ask, 10, Red);}
      */
      
      Sleep(3000);
      
      Alert("Closing Ticket # is: " + ticket);
      result = OrderClose(ticket, Lots, ((Bid+Ask)/2), 10);
      if(result == false){comment = comment + " Error closing order!-Tried to close bc price hit MABig";}
      else{comment = comment + " Order Closed because price hit MABig";}
   }
   
}
//(Bid == NormalizeDouble(MA(MA_big_period,0),Digits()))||(Ask == NormalizeDouble(MA(MA_big_period, 0),Digits()))

double MA(int period, int shift){
return(iMA(Symbol(),Period(),period,shift,0,0,0));
}

double KellyCriterion(double WinPercent, double TP, double SL){
   //K = (PB-(1-P))/B, K = % of account to risk per trade, P = win percentage historically, B = payout ratio (TP:SL)
   double P = WinPercent;
   double B = TP/SL;
   double K = (P*B-(1-P))/B;
   return(K);
}


//We declare a function CheckOpenOrders of type boolean and we want to return
//True if there are open orders for the currency pair, false if these isn't any
bool CheckOpenOrders(){
//We need to scan all the open and pending orders to see if there is there is any
//OrdersTotal return the total number of market and pending orders
//What we do is scan all orders and check if they are of the same symbol of the one where the EA is running
for( int i = 0 ; i < OrdersTotal() ; i++ ) {
//We select the order of index i selecting by position and from the pool of market/pending trades
bool apo493QsW8 = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
//If the pair of the order (OrderSymbol() is equal to the pair where the EA is running (Symbol()) then return true
if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) return(true);
}
//If the loop finishes it mean there were no open orders for that pair
return(false);
}


