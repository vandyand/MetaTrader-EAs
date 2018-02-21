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
//extern datetime start_datetime = 0;
//extern datetime split_datetime = 0;
//extern datetime end_datetime = 0;
extern double prof_factr_thresh = 0;
extern double recov_factr_thresh = 0;
extern double sharpe_thresh = 0;
extern int num_trades_thresh = 1;
extern double back_fore_ratio = 0.75;


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
int ADXPeriod = 20;
int MomPeriod = 20;
int RSIPeriod = 20;

double variables[1000];


bool first_pass = true;


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
      //double ADX_Main = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MAIN, 0);
      //double ADX_PlusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_PLUSDI, 0);
      //double ADX_MinusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MINUSDI, 0);  
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
      

      
      switch(alg_vers){
         case 10 : alg_vers_10();  break;
         case 20 : alg_vers_20();  break;
         case 30 : alg_vers_30();  break;
         case 31 : alg_vers_31();  break;
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





int firstftrade = 0;

int pass = 0;
double profit = 0;
double gross_profit = 0;
double gross_loss = 0;
double num_trades = 0;
double num_long_trades = 0;
double num_short_trades = 0;
double profit_factor = 0;
double expected_payoff = 0;
double drawdown_dol = 0;
double drawdown_pct = 0;
double recovery_factor = 0;
double sharpe = 0;
double sortino = 0;

double bprofit = 0;
double bgross_profit = 0;
double bgross_loss = 0;
double bnum_trades = 0;
double bnum_long_trades = 0;
double bnum_short_trades = 0;
double bprofit_factor = 0;
double bexpected_payoff = 0;
double bdrawdown_dol = 0;
double bdrawdown_pct = 0;
double brecovery_factor = 0;
double bsharpe = 0;
double bsortino = 0;

double fprofit = 0;
double fgross_profit = 0;
double fgross_loss = 0;
double fnum_trades = 0;
double fnum_long_trades = 0;
double fnum_short_trades = 0;
double fprofit_factor = 0;
double fexpected_payoff = 0;
double fdrawdown_dol = 0;
double fdrawdown_pct = 0;
double frecovery_factor = 0;
double fsharpe = 0;
double fsortino = 0;

double whole_counter = 0;
double bcounter = 0;
double fcounter = 0;

double OnTester(){
   
   if(OrdersHistoryTotal()>=num_trades_thresh){
      
      //Overall stuff
      pass = 0;
      double res54 = get_performance_stats(0, "none", sharpe, sortino,
                                           profit, gross_profit, gross_loss,
                                           drawdown_dol, drawdown_pct,
                                           num_long_trades, num_short_trades,num_trades);
      profit_factor = TesterStatistics(STAT_PROFIT_FACTOR);
      if(profit_factor < prof_factr_thresh){return(0);}
      profit = TesterStatistics(STAT_PROFIT);
      gross_profit = TesterStatistics(STAT_GROSS_PROFIT);
      gross_loss = TesterStatistics(STAT_GROSS_LOSS);
      num_trades = TesterStatistics(STAT_TRADES);
      expected_payoff = TesterStatistics(STAT_EXPECTED_PAYOFF);
      drawdown_dol = TesterStatistics(STAT_BALANCE_DD);
      drawdown_pct = TesterStatistics(STAT_BALANCEDD_PERCENT);
      recovery_factor = profit/drawdown_dol;
      if(recovery_factor < recov_factr_thresh){return(0);}
      
      
      //Get first forward trade
      firstftrade = int(OrdersHistoryTotal()*back_fore_ratio);
      /*
      for(int i = OrdersHistoryTotal(); i > 0; --i){
         bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         if(OrderOpenTime()>split_datetime){
            firstftrade = i;
            i=0;
         }
      }*/
      
      
      
      //backtest stuff
      /*
      for(int i = OrdersHistoryTotal()-1; i > firstftrade; --i){
         bool bres = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         bprofit += OrderProfit();
         if(OrderProfit()>0){bgross_profit += OrderProfit();}
         else{bgross_loss += OrderProfit();}
      }*/
      //bnum_trades = OrdersHistoryTotal()-1 - firstftrade;
      //double res48 = get_drawdown(firstftrade,"back",bdrawdown_dol,bdrawdown_pct);
      
      double res49 = get_performance_stats(firstftrade, "back", bsharpe, bsortino,
                                           bprofit, bgross_profit, bgross_loss,
                                           bdrawdown_dol, bdrawdown_pct,
                                           bnum_long_trades, bnum_short_trades, bnum_trades);
      if(bgross_loss!=0){bprofit_factor = bgross_profit/bgross_loss * -1;}
      if(bdrawdown_dol!=0){brecovery_factor = bprofit/bdrawdown_dol;}
      bexpected_payoff = bprofit/bnum_trades;
      
      //foretest stuff
      /*
      for(int i = firstftrade; i >= 0; --i){
         bool fres = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         fprofit += OrderProfit();
         if(OrderProfit()>0){fgross_profit += OrderProfit();}
         else{fgross_loss += OrderProfit();}         
      }*/
      //fnum_trades = firstftrade + 1;
      //double res65 = get_drawdown(firstftrade,"fore",fdrawdown_dol,fdrawdown_pct);
      double res66 = get_performance_stats(firstftrade, "fore", fsharpe, fsortino, 
                                           fprofit, fgross_profit, fgross_loss,
                                           fdrawdown_dol,fdrawdown_pct,
                                           fnum_long_trades, fnum_short_trades,fnum_trades);
      if(fgross_loss!=0){fprofit_factor = fgross_profit/fgross_loss * -1;}
      if(fdrawdown_dol!=0){frecovery_factor = fprofit/fdrawdown_dol;}
      fexpected_payoff = fprofit/fnum_trades;
      
      double optimization_criterion = sharpe*profit*OrdersHistoryTotal();
      
      if(profit_factor>=prof_factr_thresh
         &&bprofit_factor>=prof_factr_thresh
         &&fprofit_factor>=prof_factr_thresh
         &&recovery_factor>=recov_factr_thresh
         &&brecovery_factor>=recov_factr_thresh
         &&frecovery_factor>=recov_factr_thresh
         &&sharpe>=sharpe_thresh
         &&bsharpe>=sharpe_thresh
         &&fsharpe>=sharpe_thresh){
         //Write to ffffile
         int b = 0;
         b = FileOpen("Testr_Stats.csv",FILE_CSV|FILE_READ|FILE_WRITE,",");
         if(b==-1){
            Alert("File didn't open");
            Alert("Error code: ",GetLastError());
         }
         else{
            FileSeek(b,0,SEEK_END);
            FileWrite(b,bprofit,bgross_profit,bgross_loss,bnum_trades,bnum_long_trades,bnum_short_trades,
                      bprofit_factor,bexpected_payoff,brecovery_factor,bdrawdown_dol,bdrawdown_pct,bsharpe,bsortino,
                      fprofit,fgross_profit,fgross_loss,fnum_trades,fnum_long_trades,fnum_short_trades,
                      fprofit_factor,fexpected_payoff,frecovery_factor,fdrawdown_dol,fdrawdown_pct,fsharpe,fsortino,
                      profit,gross_profit,gross_loss,num_trades,num_long_trades,num_short_trades,
                      profit_factor,expected_payoff,recovery_factor,drawdown_dol,drawdown_pct,sharpe,sortino,
                      optimization_criterion,
                      iterater,sell_iterater,exit_long_itrtr,exit_short_itrtr);
            FileClose(b);
            Alert("Written to File");
         }
      }
      
      return(optimization_criterion);
   }
   return(-10);
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
   
   if(num_orders<=1){
      return(0);
   }
   
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
   
   if(num_neg_orders<=1){
      return(0);
   }
   
   double mean = sum/num_orders;
   double neg_mean = neg_sum/num_neg_orders; 
   
   double sum2_shar = 0;
   double sum2_sort = 0;
   for(int i = strt; i > end; --i){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      sum2_shar += MathPow(OrderProfit() - mean,2);
      if(OrderProfit()<=0){
         sum2_sort += MathPow(OrderProfit() - neg_mean,2);
      }
   }
   
   double var = sum2_shar/(num_orders-1);
   double neg_var = sum2_sort/(num_neg_orders-1);
   
   
   double std = (MathPow(var,0.5));
   double neg_std = (MathPow(neg_var,0.5));//(sum2,0.5)/(num_orders - 1);
   
   shsharpe = mean/std;
   ssortino = mean/neg_std;
   
   if(neg_var<=0.00005&&mean>0){
      ssortino=10;
   }
   if(var<=0.00005&&mean>0){
      shsharpe=10;
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
   
   return(1);
}

/*
double get_drawdown(int firstftrade_, string bf, double& dd, double& dd_pct){
   
   if(OrdersHistoryTotal()<=1){
      return(0);
   }
   
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
   else{return(-1);}
   
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
   return(1);
}
*/



void alg_vers_10(){
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
}

void alg_vers_20(){
   //V2-0 Doesn't use StopLoss TakeProfit. Instead it uses inverse long and short conditions
   //as exit conditions (for long and short).
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
      ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
   }
   
   if(!LongCond&&ShortCond&&!CheckOpenOrders()){
      ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);
   }
   
   bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
   int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
   
   //TODO:
   //Make the last backtest trade stop at last (seen) tick before foretest datetime.
   //Depending on the chart timeframe scale (m15, m30, etc) this will be a different time.
   //Do this for vers 30 and 31 too.
   if((type==0&&!LongCond)&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
   
   if((type==1&&!ShortCond)&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Ask,10,0);
   }
}

void alg_vers_30(){
   //V2-1 is long only with independant exit condition (termed ShortCond here)
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
      ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
   }
   
   if(((!LongCond&&ShortCond))&&CheckOpenOrders()){
      bool closer = OrderClose(ticket,Lots,Bid,10,0);
   }
}

void alg_vers_31(){
   //V2-2 is most ambitous. It uses independent enter and exit conditions for both long and short.
   //Because of this it is extremely computationally heavy. Only 6 input types makes for 810,000 runs
   //(6*5)^4=810,000. (21*20)^4 > 31 Billion! Can you say genetic algorithm? Except there's no
   //proportionality to the input iteraters.
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
      ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
   }
   
   if(!ExitShortCond&&ShortCond&&!CheckOpenOrders()){
      ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);
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
