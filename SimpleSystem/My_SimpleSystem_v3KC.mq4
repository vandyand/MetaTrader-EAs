//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                                        Copyright 2014, ForexBoat |
//|                                         http://www.forexboat.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, ForexBoat"
#property link      "http://www.forexboat.com"
#property version   "1.00"
#property strict

//#include <Characterize Trades 2010.06.08.mqh>

extern int     StartHour         = 9; 
extern int     MinPipLimit       = 0; 
extern int     TakeProfit        = 40; 
extern int     StopLoss          = 40; 
//extern double  Lots              = 1;
extern bool    UseMAFilter       = false;
extern int     MA_Period         = 100;
extern int     Magic             = 101999;
extern bool    UseKC             = true;
extern double  KCSize            = 0.5;
//extern bool    MarketExecution   = false;
//extern bool    UseTrailingSL     = false;
//extern int     TrailValue        = 40;

extern double Lots = 1;
int wins = 0;
int count = 0;
double WinPct = 0;
bool condition = false;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   string comment;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   
   double KCWinPct = 0;
   //double KCSize = 0.5;
   if(UseKC == true){
      //if(count <= 100000){KCWinPct = TakeProfit/StopLoss;}
      //else{KCWinPct = wins/count;}
      KCWinPct = TakeProfit/StopLoss;
      double RiskPct = KellyCriterion(KCWinPct, TakeProfit, StopLoss);
      double TradeSizeUSD = RiskPct * AccountBalance();
   
   
      //if(Hour() == StartHour){printf(RiskPct);}
      double val = TradeSizeUSD/(2000*Ask)*KCSize;
      Lots = ((int)(val * 100 + 0.5)/100.0);
   } 
   //else{Lots = 1;}
   
   
   ticket = FindTicket(Magic);
   
   bool res;
   res = OrderSelect(ticket, SELECT_BY_TICKET);
   
   if(OrderCloseTime() != 0 && condition == true){
      if(OrderProfit() > 0){
         wins++;
         condition = false;
      }
   }
   
   
   if(Hour() == StartHour)
   {
      comment = GetDateAndTime();
      if(IsFirstTick == true)
      {
         IsFirstTick = false;
         
         /*
         //FindTicket makes sure that the EA will pick up its orders
         //even if it is relaunched
         ticket = FindTicket(Magic);         
            
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         
         
         if(res == true)
         {
            if(OrderCloseTime() == 0)
            {
               
               
               
               
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               
               if(res2 == false)
               {
                  Alert("Error Closing Order #", ticket);
               }
            } 
         }
         */
         
         if(Open[0] < Open[StartHour] - MinPipLimit*Point) //v3.0
         {
            //check ma and open orders
            if((Close[1] < ma || UseMAFilter == false) && CheckOpenOrders()==false) //v3.0
            {
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  comment = comment + " " + "Error Sending BUY Order";
               }
               else
               {
                  comment = comment + " " + "BUY Order Succesfuly Sent";
                  count++;
                  condition = true;
               }               
            }
            else
            {
               comment = comment + " " + "MA Check Not Passed";
            }
         }
         else if(Open[0] > Open[StartHour] + MinPipLimit*Point) //v3.0
         {
            //check ma
            if((Close[1] > ma || UseMAFilter == false) && CheckOpenOrders() == false) //v3.0
            {
               
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  comment = comment + " " + "Error Sending SELL Order";
               }
               else
               {
                  comment = comment + " " + "SELL Order Succesfuly Sent";
                  count++;
                  condition = true;
               }               
            }
            else
            {
               comment = comment + " " + "MA Check Not Passed";
            }
         }
         else
         {
            comment = comment + " " + "MinPipLimit Check Not Passed";
         }

      }
      Comment(comment);
      Print(comment);
   }
   else
   {
      IsFirstTick = true;
      
      /*
      if(UseTrailingSL == true) //execute trailing stop - this has to be done on every tick
      {
         //FindTicket makes sure that the EA will pick up its orders
         //even if it is relaunched
         int ticket_trailing = FindTicket(Magic);  
         
         if(ticket_trailing > 0)
         {
            TrailingStop(ticket_trailing);      
         }
      }*/
   }

}



double OnTester(){
   

   double sharpe = get_sharpe();
   double sortino = get_sortino();
   
   
   Alert(string(sharpe)+", "+string(sortino));
   
   int e = 0;
   int counter = 0;
   //int err = 0;
   e = FileOpen("Counter.csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(e==-1){
      Alert("Counter File didn't open");
      Alert("Error code: ",GetLastError());
   }
   else{
      
      FileSeek(e,0,SEEK_SET);
      counter = FileReadNumber(e);
      counter = counter + 1;
      FileSeek(e,0,SEEK_SET);
      //Print(counter);
      FileWrite(e,counter); 
      FileClose(e);
      Alert("Written to Counter File");
   }
   
   
   

   
   int b = 0;
   b = FileOpen("Backtest_Stats.csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(b==-1){
      Alert("File didn't open");
      Alert("Error code: ",GetLastError());
   }
   else{
      FileSeek(b,0,SEEK_END);
      FileWrite(b,counter,sharpe,sortino); 
      FileClose(b);
      Alert("Written to File");
   }
   
   return(0);
}




/*
int deinit()
   {
   if(IsTesting()==true || IsOptimization()==true)
      {
      string ParameterList=StringConcatenate("TakeProfitparameter =",TakeProfitparameter,"; StopLossparameter = ",StopLossparameter,"; ");
      // setup the stringconcatencate to create a text string with the parameters your EA is optimizing
      TradeAnalysis("MySuperEA",ParameterList,false); // edit the first field to reflect your EA's name
      }
   }
*/




/*
   -------------------------------
         Auxiliary Functions     
   -------------------------------
*/

int FindTicket(int M)
{
   int ret = 0;
   
   for(int i = OrdersTotal()-1; i >= 0; i--)
   {
      bool res;
      res = OrderSelect(i, SELECT_BY_POS);
      if(res == true)
      {
         if(OrderMagicNumber() == M)
         {
            ret = OrderTicket();
            break;
         }
      }
   }
   
   return(ret);
}

string GetDateAndTime()
{
   return( string(Year())+"-"+StringFormat("%02d",Month())+"-"+StringFormat("%02d",Day())+" "+StringFormat("%02d",Hour())+":"+StringFormat("%02d",Minute()));
}

/*
int MarketOrderSend(string symbol, int cmd, double volume, double price, int slippage, double stoploss, double takeprofit, string comment, int magic)
{
   int ticket;
   
   if(MarketExecution == false)
   {
      ticket = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic);
      if(ticket <= 0) Alert("OrderSend Error: ", GetLastError());
      return(ticket);         
   }
   else
   {
      ticket = OrderSend(symbol, cmd, volume, price, slippage, 0, 0, comment, magic);
      if(ticket <= 0) Alert("OrderSend Error: ", GetLastError());
      else
      {
         bool res = OrderModify(ticket, 0, stoploss, takeprofit, 0);
         if(!res) {  Alert("OrderModify Error: ", GetLastError());
                     Alert("!!! ORDER #", ticket, " HAS NO STOPLOSS AND TAKEPROFIT --- ORDER MODIFY ERROR: GetLastError()");}
      }
      return(ticket);
   }
}
*/




/*
void TrailingStop(int ticket)                                                 
{
   bool res;                                                                  
   res = OrderSelect(ticket, SELECT_BY_TICKET);                               
   
   if(res == true)
   {
      if(OrderType() == OP_BUY)   
      {                                            
         if(Bid - OrderStopLoss() > TrailValue*Point)    //adjust stop loss if it is too far                           
         {
            res = OrderModify(OrderTicket(), 0, Bid - TrailValue*Point, OrderTakeProfit(), 0); 
            if(!res)
            {
               Alert("TrailingStop OrderModify Error: ", GetLastError());  
            }
        }
      }
         
      if(OrderType() == OP_SELL)
      {
         if(OrderStopLoss() - Ask > TrailValue*Point)    //adjust stop loss if it is too far  
         {
            res = OrderModify(OrderTicket(), 0, Ask + TrailValue*Point, OrderTakeProfit(), 0);        
            if(!res)
            {
               Alert("TrailingStop OrderModify Error: ", GetLastError());  
            }
         }
      }
   }
}
*/


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





double get_sharpe(){
   
   int num_orders = OrdersHistoryTotal();
   
   if(num_orders<=1){
      return(0);
   }
   
   double a[][2];
   ArrayResize(a,num_orders);
   double sum = 0;
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      a[i][0] = OrderProfit();
      sum += OrderProfit();
   }
   
   double mean = sum/num_orders; 
   
   double sum2 = 0;
   for(int i = 0; i < num_orders; i++){
      sum2 += MathPow(a[i][0] - mean,2);
   }
   
   double var = sum2/(num_orders-1);
   
   double std = (MathPow(var,0.5));//(sum2,0.5)/(num_orders - 1);
   
   return(mean/std);
}





double get_sortino(){
        
   int num_orders = OrdersHistoryTotal();
   
   if(num_orders<=1){
      return(0);
   }
   
   double aa[];
   ArrayResize(aa,num_orders);
   double sum = 0;
   
   double sum2 = 0;
   int num_neg_orders = 0;
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      aa[i] = OrderProfit();
      sum += OrderProfit();
      if(OrderProfit() <= 0){
         sum2 += OrderProfit();
         num_neg_orders++;
      }
   }
   
   if(num_neg_orders<=1){
      return(0);
   }
   
   double mean = sum/num_orders; 
   

   double mean2 = sum2/num_neg_orders;
   
   double sum3 = 0;
   
   for(int i = 0; i < num_orders; i++){
      if(aa[i] <= 0){
         sum3 += MathPow(aa[i] - mean2,2);
      }
   }
   
   double var = sum3/(num_neg_orders-1);
   
   double neg_std = (MathPow(var,0.5));
   
   if(neg_std!=0){
      return(mean/neg_std);
   }
   
   return(0);
}

