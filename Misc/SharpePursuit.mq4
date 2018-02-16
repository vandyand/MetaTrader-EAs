//+------------------------------------------------------------------+
//|                                                SharpePursuit.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern int enter_time = 0;
extern int exit_time = 0;
int ticket = 0;
double lots = 1;
double price = 0;
int magic = 200000;

/*
void OnInit(){
   int b;
   b = FileOpen("Backtest_Strat.csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(b==-1){
      Alert("File didn't open");
      Alert("Error code: ",GetLastError());
   }
}
*/

void OnTick(){

   if(Hour() == enter_time && !CheckOpenOrders()){
      //Bid-100*Point,Bid+100*Point
      ticket = OrderSend(Symbol(),OP_BUY,lots,Ask,10,NULL,NULL,NULL,magic,0,clrBlue);
      
   }
   
   if(Hour() == exit_time && CheckOpenOrders()){
      
      bool res = OrderClose(ticket,lots,Bid,10,clrRed);
  
   }


}

double OnTester(){
   double sharpe,sortino = 0;
   int num_orders = OrdersHistoryTotal();
   if(num_orders>0){
   
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
         a[i][1] = MathPow(a[i][0] - mean,2);
         sum2 += MathPow(a[i][0] - mean,2);
      }
      
      double var = sum2/(num_orders-1);
      
      double std = (MathPow(var,0.5));//(sum2,0.5)/(num_orders - 1);
      
      sharpe = (mean/std);
      
      
      //Sortino!!!      
      double sum3 = 0;
      int num_neg_orders = 0;
      for(int i = 0; i < num_orders; i++){
         if(a[i][0] <= 0){
            sum3 += a[i][0];
            num_neg_orders++;
         }
      }
      
      double mean2 = sum3/num_neg_orders;
      
      double sum4 = 0;
      
      for(int i = 0; i < num_orders; i++){
         if(a[i][0] <= 0){
            sum4 += MathPow(a[i][0] - mean2,2);
         }
      }
      
      double var2 = sum4/(num_neg_orders-1);
      
      double neg_std = (MathPow(var2,0.5));
      
      sortino = (mean/neg_std);
      
      Alert(string(mean)+", "+string(std)+", "+string(sharpe));
      Alert(string(num_neg_orders)+", "+string(mean2)+", "+string(neg_std)+", "+string(sortino));
   }
   else{sharpe = 0; sortino = 0;}
   
   
   int b;
   b = FileOpen("Backtest_Stats.csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(b==-1){
      Alert("File didn't open");
      Alert("Error code: ",GetLastError());
   }
   else{
      
      bool c = FileSeek(b,0,SEEK_END);
      FileWrite(b,sharpe,sortino); 
      //FileClose(b);
      Alert("Written to File");
   }
   
   return(0);
}



bool CheckOpenOrders(){
   for( int i = 0 ; i < OrdersTotal() ; i++ ) {
      bool a = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == magic ) 
         return(true);
   }
   return(false);
}



/*
   int num_orders = OrdersHistoryTotal();
   //if(num_orders>0){
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
      a[i][1] = MathPow(a[i][0] - mean,2);
      sum2 += MathPow(a[i][0] - mean,2);
   }
   
   double mean2 = sum2/num_orders;
   
   double std = (MathPow(mean2,0.5));//(sum2,0.5)/(num_orders - 1);
   
   double sharpe = (mean/std);
   */ 
   
   
  /*
   int num_orders = OrdersHistoryTotal();
   //if(num_orders>0){
   
   double sum = 0;
   double sum2 = 0;
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      sum += OrderProfit();
   }
   
   for(int i = 0; i < num_orders; i++){
      sum2 += MathPow(OrderProfit() - sum/num_orders,2);
   }
   
   double sharpe = ((sum/num_orders)/(MathPow((sum2/num_orders),0.5)));// * MathPow(252,0.5);
   
   */