//+------------------------------------------------------------------+
//|                                              New_Model_Maker.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int StopLoss = 0;
extern int TakeProfit = 0;
extern int iterater = 0;//num_unique_rows=!input_types-!(input_types-num_comparers)
extern int sell_iterater = 0;
int num_total_rows = 0;
int num_unique_rows = 0;
int num_redundant_rows = 0;
extern int num_input_types = 25;
extern int num_comparers = 2;
int unique_table[][2];
int test_table[][2];
int num_comparisons = 0;


void OnInit()
{
   
   
   //Calculate number of total rows
   num_total_rows = int(MathPow(num_input_types,num_comparers));
   
   //Calculate number of unique rows
   if((num_input_types - num_comparers) < 0){
      num_unique_rows = 0;
   }
   if(num_input_types - num_comparers >= 0){
      num_unique_rows = diff_factorial(num_input_types,num_input_types-num_comparers);
   }
   
   //Calculate number of redundant rows
   num_redundant_rows = num_total_rows - num_unique_rows;
   
   //Calculate number of comparisons
   for(int i = 1; i<=num_comparers; i++){
      num_comparisons += i-1;
   }   
   
   //ReSize arrays
   ArrayResize(unique_table,num_unique_rows);
   ArrayResize(test_table,num_total_rows);
   
   //Alert Statements
   Alert("***********************Start********************************");
   Alert("num_input_types = "+string(num_input_types));
   Alert("num_comparers = "+string(num_comparers));
   Alert("num_comparisons = "+string(num_comparisons));
   Alert("num_total_rows: "+string(num_total_rows));   
   Alert("num_unique_rows = "+string(num_unique_rows));
   Alert("num_redundant_rows = "+string(num_redundant_rows));
   
   
   
   //For loop creates the unique table
   int counter = 0;
   bool unique_cond = true;
   for(int i = 0; i < num_total_rows; ++i){
      
      for(int j = 0; j < num_comparers; ++j){
         test_table[i][j] = int((i / MathPow(num_input_types,(num_comparers - j - 1)))) % num_input_types;
      }

      for(int col = 0; col < num_comparers - 1; col++){
         for(int col2 = 1; col2 < num_comparers - col; col2++){
            if(test_table[i][col]==test_table[i][col+col2]){
               
               unique_cond = false;
               
               col2=num_comparers;
               col=num_comparers;     
            } 
         }
      }
      
      if(unique_cond){
         for(int a = 0; a < num_comparers; ++a){
            unique_table[counter][a] = test_table[i][a];
         }
         counter++;
      }
      unique_cond = true;
   }
   
   //ArrayCopy(sell_unique_table,unique_table,0,0);
   
   
      //Print unique table
   
   //for(int row = 0; row < num_unique_rows; row++){
     // if(num_comparers == 2){Alert("unique_table row = "+string(row)+" value = "+string(unique_table[row][0])+","+string(unique_table[row][1]));}
     // if(num_comparers == 3){Alert("unique_table row = "+string(row)+" value = "+string(unique_table[row][0])+","+string(unique_table[row][1])+","+string(unique_table[row][2]));}
     // if(num_comparers == 4){Alert("unique_table row = "+string(row)+" value = "+string(unique_table[row][0])+","+string(unique_table[row][1])+","+string(unique_table[row][2])+","+string(unique_table[row][3]));}
     // if(num_comparers == 4){Alert("unique_table row = "+string(row)+" value = "+string(unique_table[row][0])+","+string(unique_table[row][1])+","+string(unique_table[row][2])+","+string(unique_table[row][3])+","+string(unique_table[row][4]));} 
   //}

   //if(num_comparers == 2){Alert("unique_table row = "+string(num_unique_rows - 1)+" value = "+string(unique_table[num_unique_rows - 1][0])+","+string(unique_table[num_unique_rows - 1][1]));}
   //if(num_comparers == 3){Alert("unique_table row = "+string(num_unique_rows - 1)+" value = "+string(unique_table[num_unique_rows - 1][0])+","+string(unique_table[num_unique_rows - 1][1])+","+string(unique_table[num_unique_rows - 1][2]));}
   //if(num_comparers == 4){Alert("unique_table row = "+string(num_unique_rows - 1)+" value = "+string(unique_table[num_unique_rows - 1][0])+","+string(unique_table[num_unique_rows - 1][1])+","+string(unique_table[num_unique_rows - 1][2])+","+string(unique_table[num_unique_rows - 1][3]));}
   //if(num_comparers == 5){Alert("unique_table row = "+string(num_unique_rows - 1)+" value = "+string(unique_table[num_unique_rows - 1][0])+","+string(unique_table[num_unique_rows - 1][1])+","+string(unique_table[num_unique_rows - 1][2])+","+string(unique_table[num_unique_rows - 1][3])+","+string(unique_table[num_unique_rows - 1][4]));} 


   if(num_comparers == 2){Alert("unique_table row = "+string(iterater)+" value = "+string(unique_table[iterater][0])+","+string(unique_table[iterater][1]));}
   if(num_comparers == 3){Alert("unique_table row = "+string(iterater)+" value = "+string(unique_table[iterater][0])+","+string(unique_table[iterater][1])+","+string(unique_table[iterater][2]));}
   if(num_comparers == 4){Alert("unique_table row = "+string(iterater)+" value = "+string(unique_table[iterater][0])+","+string(unique_table[iterater][1])+","+string(unique_table[iterater][2])+","+string(unique_table[iterater][3]));}
   if(num_comparers == 5){Alert("unique_table row = "+string(iterater)+" value = "+string(unique_table[iterater][0])+","+string(unique_table[iterater][1])+","+string(unique_table[iterater][2])+","+string(unique_table[iterater][3])+","+string(unique_table[iterater][4]));} 
 
   if(num_comparers == 2){Alert("unique_table row = "+string(sell_iterater)+" value = "+string(unique_table[sell_iterater][0])+","+string(unique_table[sell_iterater][1]));}
   if(num_comparers == 3){Alert("unique_table row = "+string(sell_iterater)+" value = "+string(unique_table[sell_iterater][0])+","+string(unique_table[sell_iterater][1])+","+string(unique_table[sell_iterater][2]));}
   if(num_comparers == 4){Alert("unique_table row = "+string(sell_iterater)+" value = "+string(unique_table[sell_iterater][0])+","+string(unique_table[sell_iterater][1])+","+string(unique_table[sell_iterater][2])+","+string(unique_table[sell_iterater][3]));}
   if(num_comparers == 5){Alert("unique_table row = "+string(sell_iterater)+" value = "+string(unique_table[sell_iterater][0])+","+string(unique_table[sell_iterater][1])+","+string(unique_table[sell_iterater][2])+","+string(unique_table[sell_iterater][3])+","+string(unique_table[sell_iterater][4]));} 
  
   
}

int diff_factorial(int high_number, int low_number){
   int number = 1;
   if(high_number-low_number==0)return(1);
   else{
      for(int i = high_number; i > low_number; i--){
         number = number * i;
      }
   }
   return(number);
}


int ticket;
extern double Lots = 1;
int Magic = 200;
bool LongCond = false;
bool ShortCond = false;


int BBPeriod = 20;
double BBStdDev = 2;
int ADXPeriod = 20;
int MomPeriod = 20;
int RSIPeriod = 20;




void OnTick(){
   
   bool New_Bar = Find_New_Bar();
      
   if(New_Bar){
      
      double Price = Open[0];//0
      double SMA_200 = iMA(Symbol(), Period(), 200, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_150 = iMA(Symbol(), Period(), 150, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_100 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_50 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_25 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_5 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 0);
      double EMA_200 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_150 = iMA(Symbol(), Period(), 150, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_100 = iMA(Symbol(), Period(), 100, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_50 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_25 = iMA(Symbol(), Period(), 25, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_5 = iMA(Symbol(), Period(), 5, 0, MODE_EMA, PRICE_OPEN, 0);
      double LWMA_200 = iMA(Symbol(), Period(), 200, 0, MODE_LWMA, PRICE_OPEN, 0);
      double LWMA_150 = iMA(Symbol(), Period(), 150, 0, MODE_LWMA, PRICE_OPEN, 0);
      double LWMA_100 = iMA(Symbol(), Period(), 100, 0, MODE_LWMA, PRICE_OPEN, 0);
      double LWMA_50 = iMA(Symbol(), Period(), 50, 0, MODE_LWMA, PRICE_OPEN, 0);
      double LWMA_25 = iMA(Symbol(), Period(), 25, 0, MODE_LWMA, PRICE_OPEN, 0);
      double LWMA_5 = iMA(Symbol(), Period(), 5, 0, MODE_LWMA, PRICE_OPEN, 0);
      
      /*double SMA_200_10 = iMA(Symbol(), Period(), 200, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_150_10 = iMA(Symbol(), Period(), 150, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_100_10 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_50_10 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_25_10 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_5_10 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 10);
      double SMA_200_20 = iMA(Symbol(), Period(), 200, 0, MODE_SMA, PRICE_OPEN, 20);
      double SMA_150_20 = iMA(Symbol(), Period(), 150, 0, MODE_SMA, PRICE_OPEN, 20);
      double SMA_100_20 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 20);
      double SMA_50_20 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_OPEN, 20);
      double SMA_25_20 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 20);
      double SMA_5_20 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 20);
      
      double EMA_200_10 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_150_10 = iMA(Symbol(), Period(), 150, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_100_10 = iMA(Symbol(), Period(), 100, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_50_10 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_25_10 = iMA(Symbol(), Period(), 25, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_5_10 = iMA(Symbol(), Period(), 5, 0, MODE_EMA, PRICE_OPEN, 10);
      double EMA_200_20 = iMA(Symbol(), Period(), 200, 0, MODE_EMA, PRICE_OPEN, 20);
      double EMA_150_20 = iMA(Symbol(), Period(), 150, 0, MODE_EMA, PRICE_OPEN, 20);
      double EMA_100_20 = iMA(Symbol(), Period(), 100, 0, MODE_EMA, PRICE_OPEN, 20);
      double EMA_50_20 = iMA(Symbol(), Period(), 50, 0, MODE_EMA, PRICE_OPEN, 20);
      double EMA_25_20 = iMA(Symbol(), Period(), 25, 0, MODE_EMA, PRICE_OPEN, 20);
      double EMA_5_20 = iMA(Symbol(), Period(), 5, 0, MODE_EMA, PRICE_OPEN, 20);
      
      double LWMA_200_10 = iMA(Symbol(), Period(), 200, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_150_10 = iMA(Symbol(), Period(), 150, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_100_10 = iMA(Symbol(), Period(), 100, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_50_10 = iMA(Symbol(), Period(), 50, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_25_10 = iMA(Symbol(), Period(), 25, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_5_10 = iMA(Symbol(), Period(), 5, 0, MODE_LWMA, PRICE_OPEN, 10);
      double LWMA_200_20 = iMA(Symbol(), Period(), 200, 0, MODE_LWMA, PRICE_OPEN, 20);
      double LWMA_150_20 = iMA(Symbol(), Period(), 150, 0, MODE_LWMA, PRICE_OPEN, 20);
      double LWMA_100_20 = iMA(Symbol(), Period(), 100, 0, MODE_LWMA, PRICE_OPEN, 20);
      double LWMA_50_20 = iMA(Symbol(), Period(), 50, 0, MODE_LWMA, PRICE_OPEN, 20);
      double LWMA_25_20 = iMA(Symbol(), Period(), 25, 0, MODE_LWMA, PRICE_OPEN, 20);
      double LWMA_5_20 = iMA(Symbol(), Period(), 5, 0, MODE_LWMA, PRICE_OPEN, 20);
      */
      
      
      
      //double BB_20_2_Main = iBands(Symbol(), 0, 20, 2, 0, PRICE_OPEN, MODE_MAIN, 0);
      double BB_20_2_Upper = iBands(Symbol(), 0, 20, 2, 0, PRICE_OPEN, MODE_UPPER, 0);
      double BB_20_2_Lower = iBands(Symbol(), 0, 20, 2, 0, PRICE_OPEN, MODE_LOWER, 0);
      double BB_20_3_Upper = iBands(Symbol(), 0, 20, 3, 0, PRICE_OPEN, MODE_UPPER, 0);
      double BB_20_3_Lower = iBands(Symbol(), 0, 20, 3, 0, PRICE_OPEN, MODE_LOWER, 0);
      //double BB_50_3_Main = iBands(Symbol(), 0, 50, 3, 0, PRICE_OPEN, MODE_MAIN, 0);
      double BB_50_2_Upper = iBands(Symbol(), 0, 50, 2, 0, PRICE_OPEN, MODE_UPPER, 0);
      double BB_50_2_Lower = iBands(Symbol(), 0, 50, 2, 0, PRICE_OPEN, MODE_LOWER, 0);
      double BB_50_3_Upper = iBands(Symbol(), 0, 50, 3, 0, PRICE_OPEN, MODE_UPPER, 0);
      double BB_50_3_Lower = iBands(Symbol(), 0, 50, 3, 0, PRICE_OPEN, MODE_LOWER, 0);
      //double ADX_Main = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MAIN, 0);
      //double ADX_PlusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_PLUSDI, 0);
      //double ADX_MinusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MINUSDI, 0);  
      //double Momentum = iMomentum(Symbol(),Period(),MomPeriod,0,0);
      //double RSI = iRSI(Symbol(),Period(),RSIPeriod,0,0);
      
      
      double variables[1000];
     
      variables[0] = Price;
      variables[1] = SMA_200;
      variables[2] = SMA_150;
      variables[3] = SMA_100;
      variables[4] = SMA_50;
      variables[5] = SMA_25;
      variables[6] = SMA_5;
      variables[7] = BB_20_2_Upper;
      variables[8] = BB_20_2_Lower;
      variables[9] = BB_50_2_Upper;
      variables[10] = BB_50_2_Lower;
      variables[11] = BB_20_3_Upper;
      variables[12] = BB_20_3_Lower;
      variables[13] = BB_50_3_Upper;
      variables[14] = BB_50_3_Lower;
      variables[15] = EMA_200;
      variables[16] = EMA_150;
      variables[17] = EMA_100;
      variables[18] = EMA_50;
      variables[19] = EMA_25;
      variables[20] = EMA_5;
      variables[21] = LWMA_200;
      variables[22] = LWMA_150;
      variables[23] = LWMA_100;
      variables[24] = LWMA_50;
      variables[25] = LWMA_25;
      variables[26] = LWMA_5;
      

      
      
      //V0-0 uses static stoploss and takeprofit as (basically/functionally) exit conditions
      LongCond = true;
      ShortCond = true;
      
      for(int j = 0; j < num_comparers - 1; j++){
         if(variables[unique_table[iterater][j]]<=variables[unique_table[iterater][j+1]]){
            LongCond = false;
         }
      }
      
      for(int j = 0; j < num_comparers - 1; j++){
         if(variables[unique_table[sell_iterater][j]]<=variables[unique_table[sell_iterater][j+1]]){
            ShortCond = false;
         }
      }
      
      if(LongCond&&!ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,Bid+TakeProfit*Point,"Bought Here",Magic,0,0);
      }
      if(!LongCond&&ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Ask+StopLoss*Point,Ask-TakeProfit*Point,"Short Here",Magic,0,0);
      }
      
      
      //if(ExitCond&&CheckOpenOrders()){
        // bool rgq = OrderClose(ticket,Lots,Bid,10,0);
      //}  
   }
}



bool CheckOpenOrders(){
   for( int i = 0 ; i < OrdersTotal() ; i++ ) {
      bool a = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) 
         return(true);
   }
   return(false);
}

// Identify new bars
bool Find_New_Bar(){
   static datetime New_Time = 0;
   bool New_Bar_local = false;
   if (New_Time!= Time[0]){
      New_Time = Time[0];
      New_Bar_local = true;
      }
   return(New_Bar_local);
}


double OnTester(){
   
   double sharpe = get_sharpe();
   //double sortino = get_sortino();
   
   int num_orders = OrdersHistoryTotal();
   
   if(num_orders<=9){
      return(0);
   }
   
   double sum = 0;
   
   for(int i = 0; i < num_orders; i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      sum += OrderProfit();
   }
   
   if(sharpe>0||(num_orders>0&&sharpe==0)){
   
      return(sharpe*sum*num_orders);
      
      /*
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
         counter = int(FileReadNumber(e));
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
         FileWrite(b,counter,sharpe);//,sortino); 
         FileClose(b);
         Alert("Written to File");
         return(sharpe);
      }*/
   }
   return(0);
   
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
   
   if(var==0&&mean>0){
      return(2);
   }
   
   double std = (MathPow(var,0.5));//(sum2,0.5)/(num_orders - 1);
   
   if(std!=0){
      return(mean/std);
   }
   return(0);
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