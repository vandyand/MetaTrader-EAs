//+------------------------------------------------------------------+
//|                                              New_Model_Maker.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int alg_vers = 0;

extern int iterater = 0;
extern int sell_iterater = 0;
extern int exit_long_itrtr = 0;
extern int exit_short_itrtr = 0;
extern int adx_iterater = 0;
extern int adx_period = 14;
//extern int num_bars = 6;
extern bool use_sl = false;
extern int StopLoss = 0;
extern int TakeProfit = 0;
int num_total_rows = 0;
int num_unique_rows = 0;
int num_redundant_rows = 0;
extern int num_input_types = 25;
extern int num_comparers = 2;
int unique_table[][2];
int test_table[][2];
int num_comparisons = 0;
extern bool write_to_file = false;
extern string file_nameish = "";

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
bool ExitLongCond = false;
bool ExitShortCond = false;

int BBPeriod = 20;
double BBStdDev = 2;
int MomPeriod = 20;
int RSIPeriod = 20;

double variables[100];
double adx_variables[10];


bool first_pass = true;

//V50 stuff
int adx_unique_table[6][3] = {0,1,2, 0,2,1,  1,0,2, 1,2,0,  2,0,1, 2,1,0};
int bar_count = 0;
//

void OnTick(){
   
   
   bool New_Bar = Find_New_Bar();
      
   if(New_Bar&&!first_pass){
      
      
      double Price = Open[0];//0
      double SMA_200 = iMA(Symbol(), Period(), 200, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_150 = iMA(Symbol(), Period(), 150, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_100 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_50 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_25 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 0);
      double SMA_5 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 0);
      double EMA_250 = iMA(Symbol(), Period(), 250, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_175 = iMA(Symbol(), Period(), 175, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_125 = iMA(Symbol(), Period(), 125, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_75 = iMA(Symbol(), Period(), 75, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_35 = iMA(Symbol(), Period(), 35, 0, MODE_EMA, PRICE_OPEN, 0);
      double EMA_10 = iMA(Symbol(), Period(), 10, 0, MODE_EMA, PRICE_OPEN, 0);
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
      
      
      double ADX_Main = iADX(Symbol(), 0, adx_period, PRICE_OPEN, MODE_MAIN, 0);
      double ADX_PlusDI = iADX(Symbol(), 0, adx_period, PRICE_OPEN, MODE_PLUSDI, 0);
      double ADX_MinusDI = iADX(Symbol(), 0, adx_period, PRICE_OPEN, MODE_MINUSDI, 0);  
      //double Momentum = iMomentum(Symbol(),Period(),MomPeriod,0,0);
      //double RSI = iRSI(Symbol(),Period(),RSIPeriod,0,0);     
      
      
     
      variables[0] = Price;
      variables[1] = SMA_25;
      variables[2] = BB_20_2_Upper;
      variables[3] = BB_20_2_Lower;
      variables[4] = SMA_100;
      variables[5] = SMA_5;
      variables[6] = BB_50_3_Upper;
      variables[7] = BB_20_3_Lower;
      variables[8] = Open[24];
      variables[9] = SMA_200;
      variables[10] = SMA_50;
      variables[11] = BB_20_3_Upper;
      variables[12] = BB_50_3_Lower;
      variables[13] = Open[12];
      variables[14] = EMA_35;
      variables[15] = SMA_150;
      variables[16] = BB_50_2_Upper;
      variables[17] = BB_50_2_Lower;
      variables[18] = Open[48];
      variables[19] = EMA_10;
      variables[20] = EMA_75;
      variables[21] = EMA_125;
      variables[22] = EMA_175;
      variables[23] = LWMA_100;
      variables[24] = LWMA_50;
      variables[25] = LWMA_25;
      variables[26] = LWMA_5;
      variables[27] = LWMA_150;
      variables[28] = LWMA_200;
      variables[29] = EMA_250;
      
      adx_variables[0] = ADX_Main;
      adx_variables[1] = ADX_PlusDI;
      adx_variables[2] = ADX_MinusDI;

      
      switch(alg_vers){
         case 10 : alg_vers_10();  break;
         case 20 : alg_vers_20();  break;
         case 30 : alg_vers_30();  break;
         case 31 : alg_vers_31();  break;
         case 32 : alg_vers_32();  break;
         case 33 : alg_vers_33();  break;
         case 34 : alg_vers_34();  break;
         case 40 : alg_vers_40();  break;
         case 50 : alg_vers_50();  break;
         default: Alert("No algs called!");
      } 
      
   }
   
   if(first_pass){first_pass=false;}
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

double profit = 0;
double gross_profit = 0;
double gross_loss = 0;
double num_trades = 0;
double num_long_trades = 0;
double num_short_trades = 0;
double profit_factor = 1000000;
double expected_payoff = 0;
double drawdown_dol = 0;
double drawdown_pct = 0;
double recovery_factor = 1000000;
double sharpe = 0;
double sortino = 0;
double score0 = 0;
double score1 = 0;
double score2 = 0;
double score3 = 0;
double score4 = 0;
double score5 = 0;
double score6 = 0;

double OnTester(){
   
   double res54 = get_performance_stats(0, "none", sharpe, sortino,
                                           profit, gross_profit, gross_loss,
                                           drawdown_dol, drawdown_pct,
                                           num_long_trades, num_short_trades,num_trades);
   if(gross_loss!=0){profit_factor = gross_profit/gross_loss * -1;}
   if(drawdown_dol!=0){recovery_factor = profit/drawdown_dol;}
   if(num_trades!=0){expected_payoff = profit/num_trades;}
   score0 = sharpe;
   score1 = sharpe*num_trades;
   score2 = sharpe*sharpe*num_trades;
   score3 = sharpe*profit*num_trades;
   score4 = sharpe*profit_factor*num_trades*num_trades;
   score5 = sortino*num_trades;
   score6 = sortino*sortino*num_trades;
   
   //Write to ffffile
   if(num_trades>0){
      int b = 0;
      
      string file_name = file_nameish+"_"+string(Symbol())+"_V"+string(alg_vers)+"_NIT"+string(num_input_types)+".csv";
      b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");
      if(b==-1){
         Alert("File didn't open");
         Alert("Error code: ",GetLastError());
      }
      else{
         FileSeek(b,0,SEEK_END);
         FileWrite(b,iterater,sell_iterater,exit_long_itrtr,exit_short_itrtr,profit,gross_profit,
         gross_loss,num_trades,num_long_trades,num_short_trades,profit_factor,expected_payoff,
         recovery_factor,drawdown_dol,drawdown_pct,sharpe,sortino,score0,score1,score2,score3,
         score4,score5,score6,"");
         for(int i=0; i<OrdersHistoryTotal(); i++){
            bool aaa = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
            if(aaa==TRUE){
               FileSeek(b,-2,SEEK_END);
               FileWrite(b,string(string(OrderOpenTime())+"|"+string(OrderCloseTime())+"|"+string(OrderType())+"|"+string(OrderProfit())+"^"));
            }
         }
         FileClose(b);
         Alert("Written to File");
      }
   }
   return(sharpe);
}

double get_performance_stats(int firstftrade_, string bf, double& shsharpe, double& ssortino,
                             double& pprofit, double& ggross_profit, double& ggross_loss,
                             double& dd, double& dd_pct, double& nnum_long_trades, double& nnum_short_trades,
                             double& counterr){
   
   int num_orders = 0;
   int strt = 0;
   int end = 0;
   
   if(bf=="fore"){
      strt = OrdersHistoryTotal()-1;
      end = firstftrade_;
      num_orders = OrdersHistoryTotal()-firstftrade_-1;
   }
   else if(bf=="back"){
      strt = firstftrade_;
      end = -1;
      num_orders = firstftrade_ + 1;
   }
   else if(bf=="none"){
      strt = OrdersHistoryTotal()-1;
      end = -1;
      num_orders = OrdersHistoryTotal();
   }
   else{
      return(-1);
   }
   
   double local_drawdown = 0;
   double max_drawdown = 0;
   double max_drawdown_pct = 0;
   double high_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double local_low_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double curr_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   
   for(int i = strt; i > end; --i){
      bool ddres = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      curr_bal += OrderProfit();
      if(curr_bal > high_bal){
         high_bal = curr_bal;
         local_low_bal = curr_bal;
      }
      if(curr_bal < local_low_bal){
         local_low_bal = curr_bal;
      }
      local_drawdown = high_bal - local_low_bal;
      if(local_drawdown > max_drawdown){
         max_drawdown = local_drawdown;
         max_drawdown_pct = max_drawdown/high_bal*100;
      }
   }
   
   dd = max_drawdown;
   dd_pct = max_drawdown_pct;
   
   
   double sum = 0;
   double pos_sum = 0;
   double neg_sum = 0;
   int num_neg_orders = 0;
   
   int num_long_orders = 0;
   int num_short_orders = 0;
   
   int order_type = -1;
   
   int counter = 0;
   
   for(int i = strt; i > end; --i){
      counter++;
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      order_type = OrderType();//0 ==> BUY ORDER, 1 ==> SELL ORDER (LONG, SHORT)
      sum += OrderProfit();
      if(OrderProfit()<=0){
         neg_sum += OrderProfit();
         num_neg_orders++;
      }
      else{
         pos_sum+=OrderProfit();
      }
      if(order_type==0){//long order!
         num_long_orders++;
      }
      else if(order_type==1){//short order
         num_short_orders++; 
      }
      else{return(-2);}
   }
   counterr = counter;
   pprofit = sum;
   ggross_profit = pos_sum;
   ggross_loss = neg_sum;
   
   nnum_long_trades = num_long_orders;
   nnum_short_trades = num_short_orders;
   
   double mean = 0;
   double neg_mean = 0;
   if(num_orders!=0){mean = sum/num_orders;}
   if(num_neg_orders!=0){neg_mean = neg_sum/num_neg_orders;}
   
   double sum2_shar = 0;
   double sum2_sort = 0;
   for(int i = strt; i > end; --i){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      sum2_shar += MathPow(OrderProfit() - mean,2);
      if(OrderProfit()<=0){
         sum2_sort += MathPow(OrderProfit() - neg_mean,2);
      }
   }
   
   double var = 0;
   double neg_var = 0;
   if((num_orders-1)!=0){var = sum2_shar/(num_orders-1);}
   if((num_neg_orders-1)!=0){neg_var = sum2_sort/(num_neg_orders-1);}
   
   
   double std = (MathPow(var,0.5));
   double neg_std = (MathPow(neg_var,0.5));//(sum2,0.5)/(num_orders - 1);
   
   if(std!=0){shsharpe = mean/std;}
   if(neg_std!=0){ssortino = mean/neg_std;}
   
   if(neg_var<=0.0001&&mean>0){
      ssortino=num_orders*2;
   }
   if(var<=0.0001&&mean>0){
      shsharpe=num_orders*2;
   }
   
   return(1);
}

void alg_vers_10(){
   //V0-0 uses static stoploss and takeprofit as (basically/functionally) exit conditions
   //use_sl has no effect here. It always uses sl, tp.
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
}

void alg_vers_20(){
   //V2-0 Doesn't use StopLoss TakeProfit. Instead it uses inverse long and short conditions
   //as exit conditions (for long and short). Unless use_sl is true, then it uses sl.
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
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(!LongCond&&ShortCond&&!CheckOpenOrders()){
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Ask+StopLoss*Point,NULL,"Short Here",Magic,0,0);}
   }
   
   bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
   int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
   
   if((type==0&&!LongCond)&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
   
   if((type==1&&!ShortCond)&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Ask,10,0);
   }
}

void alg_vers_30(){
   //V2-1 is long only with independant exit condition (termed ShortCond here)
   //if use_sl is on it uses sl.
   LongCond = true;//Acts as enter (long only) condition in V2-1
   ShortCond = true;//Acts as exit condition in V2-1
   
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
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(((ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
}

void alg_vers_31(){
   //V2-2 is most ambitous. It uses independent enter and exit conditions for both long and short.
   //Because of this it is extremely computationally heavy. Only 6 input types makes for 810,000 runs
   //(6*5)^4=810,000. (21*20)^4 > 31 Billion! Can you say genetic algorithm? Except there's no
   //proportionality to the input iteraters.
   //If use_sl is true it uses stoploss in addition to exit conditions.
   LongCond = true;
   ShortCond = true;
   ExitLongCond = true;
   ExitShortCond = true;
   
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
   
   for(int j = 0; j < num_comparers - 1; j++){
      if(variables[unique_table[exit_long_itrtr][j]]<=variables[unique_table[exit_long_itrtr][j+1]]){
         ExitLongCond = false;
      }
   }
   
   for(int j = 0; j < num_comparers - 1; j++){
      if(variables[unique_table[exit_short_itrtr][j]]<=variables[unique_table[exit_short_itrtr][j+1]]){
         ExitShortCond = false;
      }
   }
   
   if(LongCond&&!ExitLongCond&&!CheckOpenOrders()){
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(!ExitShortCond&&ShortCond&&!CheckOpenOrders()){
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Ask+StopLoss*Point,NULL,"Short Here",Magic,0,0);}
   }
   
   bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
   int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
   
   if(((type==0&&ExitLongCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
   
   if(((type==1&&ExitShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Ask,10,0);
   }
}

void alg_vers_32(){//This is copied from vers_30 so some of the terminology is oposite.
   //V2-3 is short only with independant exit condition (termed ShortCond here)
   //if use_sl is on it uses sl.
   LongCond = true;//Acts as enter (short only) condition in V2-1
   ShortCond = true;//Acts as exit condition in V2-1
   
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
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Ask+StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(((ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Ask,10,0);
   }
}

void alg_vers_33(){
   //33 is the same as 31 except the exit condition has !LongCond||ShortCond instead of just ShortCond
   LongCond = true;//Acts as enter (long only) condition in V2-1
   ShortCond = true;//Acts as exit condition in V2-1
   
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
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(((!LongCond||ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
}

void alg_vers_34(){
   //This is the same as 32 except exit condition is !LongCond||ShortCond instead of just ShortCond
   LongCond = true;//Acts as enter (short only) condition in V2-1
   ShortCond = true;//Acts as exit condition in V2-1
   
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
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,Ask+StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(((!LongCond||ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Ask,10,0);
   }
}

void alg_vers_40(){
   //V40 is long only with independant exit condition (termed ShortCond here)
   //if use_sl is on it uses sl.
   //First version to use adx_variables in addition to other vars.
   LongCond = true;//Acts as enter (long only) condition
   ShortCond = true;//Acts as exit condition
   
   for(int j = 0; j < num_comparers - 1; j++){
      if(variables[unique_table[iterater][j]]<=variables[unique_table[iterater][j+1]]){
         if((adx_variables[adx_unique_table[adx_iterater][0]]<=adx_variables[adx_unique_table[adx_iterater][1]])){//&&
         //(adx_variables[adx_unique_table[adx_iterater][1]]<=adx_variables[adx_unique_table[adx_iterater][2]])){
            LongCond = false;
         }
      }
   }
   
   for(int j = 0; j < num_comparers - 1; j++){
      if(variables[unique_table[sell_iterater][j]]<=variables[unique_table[sell_iterater][j+1]]){
         //if(variables[unique_table[adx_iterater][0]]<=variables[unique_table[adx_iterater][1]]){
            ShortCond = false;
         //}
      }
   }
   
   if(LongCond&&!ShortCond&&!CheckOpenOrders()){
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if(((ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
}

void alg_vers_50(){
   //V50 is a new attempt just using adx. We'll see how it goes.
   LongCond = false;//Acts as enter (long only) condition
   ShortCond = false;//Acts as exit condition
   
   //if(CheckOpenOrders()){bar_count++;}
   
   if((adx_variables[adx_unique_table[adx_iterater][0]]>=adx_variables[adx_unique_table[adx_iterater][1]])&&
   (adx_variables[adx_unique_table[adx_iterater][1]]>=adx_variables[adx_unique_table[adx_iterater][2]])){
      LongCond = true;
      ShortCond = false;
   }
   else{
      LongCond = false;
      ShortCond = true;
      //bar_count = 0;
   }
   
   if(LongCond&&!ShortCond&&!CheckOpenOrders()){//&&bar_count==0){
      if(use_sl==false){ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);}
      else{ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,Bid-StopLoss*Point,NULL,"Bought Here",Magic,0,0);}
   }
   
   if((ShortCond&&CheckOpenOrders())){//||bar_count>=num_bars){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
}

/*
void SuperFunc(int& valueForReturn1,double& valueForReturn2,string& valueForReturn3)
{
   valueForReturn1=100;
   valueForReturn2=300.0;
   valueForReturn3="it works!!";
}

int value1=0;
double value2=0.0;
string value3="";
 
SuperFunc(value1,value2,value3);
MessageBox("value1="+value1+" value2="+value2+" value3="+value3);
*/
