//+------------------------------------------------------------------+
//|                                              New_Model_Maker.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//------------------------------------------------------------------------------------------
//Notes:
//EchoDiscreteModelMaker is the same as DeltaDiscreteModelMaker with file writing statistics
//added for verification. Also included is functionality to close open trades when transitioning
//from back to fore trades (as will inevitably happen in real life).
//
//------------------------------------------------------------------------------------------






extern int Long_Back_1;
extern int Long_Back_2;
extern int Short_Back_1;
extern int Short_Back_2;
extern int Open_Bars;


extern double prof_factr_thresh = 0;
extern double recov_factr_thresh = 0;
extern double sharpe_thresh = 0;
extern double score_thresh = 0;
extern int num_trades_thresh = 1;
extern int split_datetime = 0;
extern bool write_to_file = false;
extern int file_name_prefix = 0;
extern int score_type = 0;



int ticket;
extern double Lots = 0.01;
int Magic = 200;
bool LongCond = false;
bool ShortCond = false;
bool ExitLongCond = false;
bool ExitShortCond = false;

bool first_pass = true;
bool first_fore_pass = false;
bool fore = false;
datetime cur_time = TimeLocal();
datetime split = split_datetime;

int open_bars = 0;

void OnTick(){
   cur_time = TimeCurrent();
   if(TimeMonth(cur_time)>=TimeMonth(split)&&TimeDay(cur_time)>=TimeDay(split)&&fore==false){
      first_fore_pass = true;
      Alert("first fore pass!");
      fore = true;
   }
   
   bool New_Bar = Find_New_Bar();
      
   if(New_Bar&&!first_pass&&((Long_Back_1!=Long_Back_2)||(Short_Back_1!=Short_Back_2))){
      
      
      LongCond = false;
      ShortCond = false;
      
      if(Open[Long_Back_1] > Open[Long_Back_2]){
         LongCond = true;
      }
      
      if(Open[Short_Back_1] > Open[Short_Back_2]){
         ShortCond = true;
      }
      
      if(LongCond&&!ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
      }
      
      if(!LongCond&&ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);
      }
      
      if(CheckOpenOrders()){
         open_bars++;
      }
      
      bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
      int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
      
      
      if(type==0&&(open_bars==Open_Bars||first_fore_pass)){
         bool closer = OrderClose(ticket,Lots,Bid,10,0);
         open_bars = 0;
      }
      
      if(type==1&&(open_bars==Open_Bars||first_fore_pass)){
         bool closer = OrderClose(ticket,Lots,Ask,10,0);
         open_bars = 0;
      }
      
   }
   
   if(first_pass){first_pass=false;}
   if(first_fore_pass){first_fore_pass=false;}
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
double score0 = 0;
double score1 = 0;
double score2 = 0;
double score3 = 0;
double score4 = 0;
double score5 = 0;
double score6 = 0;
double score7 = 0;
double score8 = 0;
double score9 = 0;
double score10 = 0;
double score11 = 0;
double score12 = 0;
double score13 = 0;
double score14 = 0;
double score15 = 0;
double score16 = 0;
double score17 = 0;

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
double bscore0 = 0;
double bscore1 = 0;
double bscore2 = 0;
double bscore3 = 0;
double bscore4 = 0;
double bscore5 = 0;
double bscore6 = 0;
double bscore7 = 0;
double bscore8 = 0;
double bscore9 = 0;
double bscore10 = 0;
double bscore11 = 0;
double bscore12 = 0;
double bscore13 = 0;
double bscore14 = 0;
double bscore15 = 0;
double bscore16 = 0;
double bscore17 = 0;

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
double fscore0 = 0;
double fscore1 = 0;
double fscore2 = 0;
double fscore3 = 0;
double fscore4 = 0;
double fscore5 = 0;
double fscore6 = 0;
double fscore7 = 0;
double fscore8 = 0;
double fscore9 = 0;
double fscore10 = 0;
double fscore11 = 0;
double fscore12 = 0;
double fscore13 = 0;
double fscore14 = 0;
double fscore15 = 0;
double fscore16 = 0;
double fscore17 = 0;

double whole_counter = 0;
double bcounter = 0;
double fcounter = 0;

double OnTester(){


   //if(OrdersHistoryTotal()>=num_trades_thresh){
      
      
      
      //Overall stuff
      pass = 0;
      double res54 = get_performance_stats(0, "none", sharpe, sortino,
                                           profit, gross_profit, gross_loss,
                                           drawdown_dol, drawdown_pct,
                                           num_long_trades, num_short_trades,num_trades);
      if(gross_loss!=0){profit_factor = gross_profit/gross_loss * -1;}
      else{profit_factor = num_trades;}
      if(drawdown_dol!=0){recovery_factor = profit/drawdown_dol;}
      if(num_trades!=0){expected_payoff = profit/num_trades;}
      if(num_trades>=num_trades_thresh){
         if(profit>0){score0 = profit;}
         if(profit>0){score1 = sharpe;}
         if(profit>0){score2 = sharpe*num_trades;}
         if(profit>0){score3 = sharpe*profit;}
         if(profit>0){score4 = sharpe*num_trades*profit;}
         if(profit>0){score5 = sharpe*num_trades*profit_factor;}
         if(profit>0){score6 = sharpe*num_trades*profit*profit_factor;}
         if(profit>0){score7 = sortino;}
         if(profit>0){score8 = sortino*num_trades;}
         if(profit>0){score9 = sortino*profit;}
         if(profit>0){score10 = sortino*num_trades*profit;}
         if(profit>0){score11 = sortino*num_trades*profit_factor;}
         if(profit>0){score12 = sortino*num_trades*profit*profit_factor;}
         if(profit>0){score13 = sharpe*sortino;}
         if(profit>0){score14 = sharpe*sortino*num_trades;}
         if(profit>0){score15 = sharpe*sortino*profit;}
         if(profit>0){score16 = sharpe*sortino*num_trades*profit_factor;}
         if(profit>0){score17 = sharpe*sortino*num_trades*profit*profit_factor;}
      }
      
      //Get first forward trade
      
      bool found = false;
      
      for(int i = 0; i < OrdersHistoryTotal(); i++){
         bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
         if(OrderOpenTime()>split_datetime){
            firstftrade = i-1;
            i=OrdersHistoryTotal();
            found = true;
         }
      }
      if(!found){firstftrade = OrdersHistoryTotal()-1;}
      
      
      //backtest stuff      
      double res49 = get_performance_stats(firstftrade, "back", bsharpe, bsortino,
                                           bprofit, bgross_profit, bgross_loss,
                                           bdrawdown_dol, bdrawdown_pct,
                                           bnum_long_trades, bnum_short_trades, bnum_trades);
      if(bgross_loss!=0){bprofit_factor = bgross_profit/bgross_loss * -1;}
      else{bprofit_factor = bnum_trades;}
      if(bdrawdown_dol!=0){brecovery_factor = bprofit/bdrawdown_dol;}
      if(bnum_trades!=0){bexpected_payoff = bprofit/bnum_trades;}
      if(num_trades>=num_trades_thresh){
         if(bprofit>0){bscore0 = bprofit;}
         if(bprofit>0){bscore1 = bsharpe;}
         if(bprofit>0){bscore2 = bsharpe*bnum_trades;}
         if(bprofit>0){bscore3 = bsharpe*bprofit;}
         if(bprofit>0){bscore4 = bsharpe*bnum_trades*bprofit;}
         if(bprofit>0){bscore5 = bsharpe*bnum_trades*bprofit_factor;}
         if(bprofit>0){bscore6 = bsharpe*bnum_trades*bprofit*bprofit_factor;}
         if(bprofit>0){bscore7 = bsortino;}
         if(bprofit>0){bscore8 = bsortino*bnum_trades;}
         if(bprofit>0){bscore9 = bsortino*bprofit;}
         if(bprofit>0){bscore10 = bsortino*bnum_trades*bprofit;}
         if(bprofit>0){bscore11 = bsortino*bnum_trades*bprofit_factor;}
         if(bprofit>0){bscore12 = bsortino*bnum_trades*bprofit*bprofit_factor;}
         if(bprofit>0){bscore13 = bsharpe*bsortino;}
         if(bprofit>0){bscore14 = bsharpe*bsortino*bnum_trades;}
         if(bprofit>0){bscore15 = bsharpe*bsortino*bprofit;}
         if(bprofit>0){bscore16 = bsharpe*bsortino*bnum_trades*bprofit_factor;}
         if(bprofit>0){bscore17 = bsharpe*bsortino*bnum_trades*bprofit*bprofit_factor;}
      }
      
      if(write_to_file==false){
         switch(score_type){
            case 0 : return(bscore0);  break;
            case 1 : return(bscore1);  break;
            case 2 : return(bscore2);  break;
            case 3 : return(bscore3);  break;
            case 4 : return(bscore4);  break;
            case 5 : return(bscore5);  break;
            case 6 : return(bscore6);  break;
            case 7 : return(bscore7);  break;
            case 8 : return(bscore8);  break;
            case 9 : return(bscore9);  break;
            case 10 : return(bscore10);  break;
            case 11 : return(bscore11);  break;
            case 12 : return(bscore12);  break;
            case 13 : return(bscore13);  break;
            case 14 : return(bscore14);  break;
            case 15 : return(bscore15);  break;
            case 16 : return(bscore16);  break;
            case 17 : return(bscore17);  break;
            default: Alert("Invalid score_type!");
         } 
      }
      
      //foretest stuff
      double res66 = get_performance_stats(firstftrade, "fore", fsharpe, fsortino, 
                                           fprofit, fgross_profit, fgross_loss,
                                           fdrawdown_dol,fdrawdown_pct,
                                           fnum_long_trades, fnum_short_trades,fnum_trades);
      if(fgross_loss!=0){fprofit_factor = fgross_profit/fgross_loss * -1;}
      else{fprofit_factor = fnum_trades;}
      if(fdrawdown_dol!=0){frecovery_factor = fprofit/fdrawdown_dol;}
      if(fnum_trades!=0){fexpected_payoff = fprofit/fnum_trades;}
      if(num_trades>=num_trades_thresh){
         if(fprofit>0){fscore0 = fprofit;}
         if(fprofit>0){fscore1 = fsharpe;}
         if(fprofit>0){fscore2 = fsharpe*fnum_trades;}
         if(fprofit>0){fscore3 = fsharpe*fprofit;}
         if(fprofit>0){fscore4 = fsharpe*fnum_trades*fprofit;}
         if(fprofit>0){fscore5 = fsharpe*fnum_trades*fprofit_factor;}
         if(fprofit>0){fscore6 = fsharpe*fnum_trades*fprofit*fprofit_factor;}
         if(fprofit>0){fscore7 = fsortino;}
         if(fprofit>0){fscore8 = fsortino*fnum_trades;}
         if(fprofit>0){fscore9 = fsortino*fprofit;}
         if(fprofit>0){fscore10 = fsortino*fnum_trades*fprofit;}
         if(fprofit>0){fscore11 = fsortino*fnum_trades*fprofit_factor;}
         if(fprofit>0){fscore12 = fsortino*fnum_trades*fprofit*fprofit_factor;}
         if(fprofit>0){fscore13 = fsharpe*fsortino;}
         if(fprofit>0){fscore14 = fsharpe*fsortino*fnum_trades;}
         if(fprofit>0){fscore15 = fsharpe*fsortino*fprofit;}
         if(fprofit>0){fscore16 = fsharpe*fsortino*fnum_trades*fprofit_factor;}
         if(fprofit>0){fscore17 = fsharpe*fsortino*fnum_trades*fprofit*fprofit_factor;}
      }
      
      if(true){
      //profit_factor>=prof_factr_thresh
         //&&recovery_factor>=recov_factr_thresh
         //&&sharpe>=sharpe_thresh
         //&&num_trades>=num_trades_thresh){
         
         //Write to ffffile
         int b = 0;
         
         string file_name = string(file_name_prefix)+"_"+string(Symbol())+".csv";
         b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");
         if(b==-1){
            Alert("File didn't open");
            Alert("Error code: ",GetLastError());
         }
         else{
            FileSeek(b,0,SEEK_END);
            FileWrite(b,
                      DoubleToStr(profit,2),DoubleToStr(bprofit,2),DoubleToStr(fprofit,2),
                      DoubleToStr(bprofit,2),DoubleToStr(bgross_profit,2),DoubleToStr(bgross_loss,2),
                      bnum_trades,bnum_long_trades,bnum_short_trades,
                      DoubleToStr(bprofit_factor,2),DoubleToStr(bexpected_payoff,2),DoubleToStr(brecovery_factor,2),
                      DoubleToStr(bdrawdown_dol,2),DoubleToStr(bdrawdown_pct,3),
                      DoubleToStr(bscore0,2),DoubleToStr(bscore1,2),
                      DoubleToStr(bscore2,2),DoubleToStr(bscore3,2),
                      DoubleToStr(bscore4,2),DoubleToStr(bscore5,2),
                      DoubleToStr(bscore6,2),DoubleToStr(bscore7,2),
                      DoubleToStr(bscore8,2),DoubleToStr(bscore9,2),
                      DoubleToStr(bscore10,2),DoubleToStr(bscore11,2),
                      DoubleToStr(bscore12,2),DoubleToStr(bscore13,2),
                      DoubleToStr(bscore14,2),DoubleToStr(bscore15,2),
                      DoubleToStr(bscore16,2),DoubleToStr(bscore17,2),
                      DoubleToStr(fprofit,2),
                      DoubleToStr(fprofit_factor,2),DoubleToStr(fexpected_payoff,2),DoubleToStr(frecovery_factor,2),
                      DoubleToStr(fdrawdown_dol,2),DoubleToStr(fdrawdown_pct,3),
                      DoubleToStr(fscore0,2),DoubleToStr(fscore1,2),
                      DoubleToStr(fscore2,2),DoubleToStr(fscore3,2),
                      DoubleToStr(fscore4,2),DoubleToStr(fscore5,2),
                      DoubleToStr(fscore6,2),DoubleToStr(fscore7,2),
                      DoubleToStr(fscore8,2),DoubleToStr(fscore9,2),
                      DoubleToStr(fscore10,2),DoubleToStr(fscore11,2),
                      DoubleToStr(fscore12,2),DoubleToStr(fscore13,2),
                      DoubleToStr(fscore14,2),DoubleToStr(fscore15,2),
                      DoubleToStr(fscore16,2),DoubleToStr(fscore17,2),
                      num_trades,
                      firstftrade,
                      Long_Back_1,Long_Back_2,Short_Back_1,Short_Back_2,Open_Bars
                      );
            FileClose(b);
            Alert("Written to File");
         }
      }
      
      switch(score_type){
            case 0 : return(bscore0);  break;
            case 1 : return(bscore1);  break;
            case 2 : return(bscore2);  break;
            case 3 : return(bscore3);  break;
            case 4 : return(bscore4);  break;
            case 5 : return(bscore5);  break;
            case 6 : return(bscore6);  break;
            case 7 : return(bscore7);  break;
            case 8 : return(bscore8);  break;
            case 9 : return(bscore9);  break;
            case 10 : return(bscore10);  break;
            case 11 : return(bscore11);  break;
            case 12 : return(bscore12);  break;
            case 13 : return(bscore13);  break;
            case 14 : return(bscore14);  break;
            case 15 : return(bscore15);  break;
            case 16 : return(bscore16);  break;
            case 17 : return(bscore17);  break;
            default: return(-1);
         } 
   //}
   //return(-1);
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