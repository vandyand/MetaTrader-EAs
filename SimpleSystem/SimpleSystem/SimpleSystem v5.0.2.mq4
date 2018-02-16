//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                                        Copyright 2014, ForexBoat |
//|                                         http://www.forexboat.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, ForexBoat"
#property link      "http://www.forexboat.com"
#property version   "1.00"
#property strict

extern int     StartHour      = 9; 
extern int     MinPipLimit    = 0; 
extern int     TakeProfit     = 40; 
extern int     StopLoss       = 40; 
extern double  Lots           = 1;
extern bool    UseMAFilter    = false;
extern int     MA_Period      = 100;

int Magic = 50262802;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour)
   {
      if(IsFirstTick == true)
      {
         IsFirstTick = false;
      
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
      
         if(Open[0] < Open[StartHour] - MinPipLimit*Point) //v3.0
         {
            //check ma
            if(Close[1] < ma || UseMAFilter == false) //v3.0
            {
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }
         else if(Open[0] > Open[StartHour] + MinPipLimit*Point) //v3.0
         {
            //check ma
            if(Close[1] > ma || UseMAFilter == false) //v3.0
            {
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }

      }
   }
   else
   {
      IsFirstTick = true;
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
      FileWrite(b,counter,StartHour,TakeProfit,StopLoss,sharpe,sortino); 
      FileClose(b);
      Alert("Written to File");
   }
   
   return(0);
}






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





double get_sharpe(){
   
   int num_orders = OrdersHistoryTotal();
   
   if(num_orders<=1){
      return(0);
   }
   
   double a[];
   ArrayResize(a,num_orders);
   double sum = 0;
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      a[i] = OrderProfit();
      sum += OrderProfit();
   }
   
   double mean = sum/num_orders; 
   
   double sum2 = 0;
   for(int i = 0; i < num_orders; i++){
      sum2 += MathPow(a[i] - mean,2);
   }
   
   double var = sum2/(num_orders-1);
   
   double std = (MathPow(var,0.5));
   
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
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      aa[i] = OrderProfit();
      sum += OrderProfit();
      if(OrderProfit() <= 0){
         sum2 += OrderProfit();
      }
   }
   
   
   double mean = sum/num_orders; 
   
   double mean2 = sum2/num_orders;
   
   double sum3 = 0;
   
   for(int i = 0; i < num_orders; i++){
      if(aa[i] <= 0){
         sum3 += MathPow(aa[i] - mean2,2);
      }
   }
   
   double var = sum3/(num_orders-1);
   
   double neg_std = (MathPow(var,0.5));
   
   write_to_file("holder",num_orders,mean2,sum3,var,neg_std);
   
   if(neg_std!=0){
      return(mean/neg_std);
   }
   
   return(0);
}




void write_to_file(string filename,double a=0,double b=0,double c=0,double d=0,double e=0,double f=0,double g=0,double h=0){
   int file = 0;
   file = FileOpen(filename+".csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(file==-1){
      Alert("File didn't open");
      Alert("Error code: ",GetLastError());
   }
   else{
      FileSeek(file,0,SEEK_END);
      FileWrite(file,a,b,c,d,e,f,g,h); 
      FileClose(file);
      Alert("Written to File");
   }
}