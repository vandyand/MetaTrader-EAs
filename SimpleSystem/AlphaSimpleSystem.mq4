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

extern double prof_factr_thresh = 0;
extern double recov_factr_thresh = 0;
extern double sharpe_thresh = 0;
extern int num_trades_thresh = 1;
extern string split_type = "";
extern datetime split_datetime = 0;
extern double back_fore_ratio = 0;
extern bool write_to_file = false;
extern string file_nameish = "";
extern int score_type = 0;

int Magic = 50262802;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour){
      if(IsFirstTick == true){
         IsFirstTick = false;
      
         //FindTicket makes sure that the EA will pick up its orders
         //even if it is relaunched
         ticket = FindTicket(Magic);         
            
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         if(res == true){
            if(OrderCloseTime() == 0){
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               
               if(res2 == false){
                  Alert("Error Closing Order #", ticket);
               }
            } 
         }
      
         if(Open[0] < Open[StartHour] - MinPipLimit*Point){
            if(Close[1] < ma || UseMAFilter == false){
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0){
                  Alert("Error Sending Order!");
               }
            }
         }
         else if(Open[0] > Open[StartHour] + MinPipLimit*Point){
            //check ma
            if(Close[1] > ma || UseMAFilter == false){
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0){
                  Alert("Error Sending Order!");
               }
            }
         }
      }
   }
   else{
      IsFirstTick = true;
   }

}


int FindTicket(int M){

   int ret = 0;
   
   for(int i = OrdersTotal()-1; i >= 0; i--){
      bool res;
      res = OrderSelect(i, SELECT_BY_POS);
      if(res == true){
         if(OrderMagicNumber() == M){
            ret = OrderTicket();
            break;
         }
      }
   }
   return(ret);
}





int firstftrade = 0;

int pass = 0;
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

double bprofit = 0;
double bgross_profit = 0;
double bgross_loss = 0;
double bnum_trades = 0;
double bnum_long_trades = 0;
double bnum_short_trades = 0;
double bprofit_factor = 1000000;
double bexpected_payoff = 0;
double bdrawdown_dol = 0;
double bdrawdown_pct = 0;
double brecovery_factor = 1000000;
double bsharpe = 0;
double bsortino = 0;
double bscore0 = 0;
double bscore1 = 0;
double bscore2 = 0;
double bscore3 = 0;
double bscore4 = 0;
double bscore5 = 0;
double bscore6 = 0;

double fprofit = 0;
double fgross_profit = 0;
double fgross_loss = 0;
double fnum_trades = 0;
double fnum_long_trades = 0;
double fnum_short_trades = 0;
double fprofit_factor = 1000000;
double fexpected_payoff = 0;
double fdrawdown_dol = 0;
double fdrawdown_pct = 0;
double frecovery_factor = 1000000;
double fsharpe = 0;
double fsortino = 0;
double fscore0 = 0;
double fscore1 = 0;
double fscore2 = 0;
double fscore3 = 0;
double fscore4 = 0;
double fscore5 = 0;
double fscore6 = 0;

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
      if(drawdown_dol!=0){recovery_factor = profit/drawdown_dol;}
      if(num_trades!=0){expected_payoff = profit/num_trades;}
      if(num_trades>=num_trades_thresh){
         if(profit>0){score0 = sharpe;}
         if(profit>0){score1 = sharpe*num_trades;}
         if(profit>0){score2 = sharpe*sharpe*num_trades;}
         if(profit>0){score3 = sharpe*profit*num_trades;}
         if(profit>0){score4 = sharpe*profit_factor*num_trades*num_trades;}
         if(profit>0){score5 = sortino*num_trades;}
         if(profit>0){score6 = sortino*sortino*num_trades;}
      }
      /*
      profit_factor = TesterStatistics(STAT_PROFIT_FACTOR);
      //if(profit_factor < prof_factr_thresh){return(0);}
      profit = TesterStatistics(STAT_PROFIT);
      gross_profit = TesterStatistics(STAT_GROSS_PROFIT);
      gross_loss = TesterStatistics(STAT_GROSS_LOSS);
      num_trades = TesterStatistics(STAT_TRADES);
      expected_payoff = TesterStatistics(STAT_EXPECTED_PAYOFF);
      drawdown_dol = TesterStatistics(STAT_BALANCE_DD);
      drawdown_pct = TesterStatistics(STAT_BALANCEDD_PERCENT);
      if(drawdown_dol!=0){recovery_factor = profit/drawdown_dol;}
      //if(recovery_factor < recov_factr_thresh){return(0);}
      if(profit>0){score = sharpe*profit*num_trades;}
      */
      if(write_to_file==false){
         switch(score_type){
            case 0 : return(score0);  break;
            case 1 : return(score1);  break;
            case 2 : return(score2);  break;
            case 3 : return(score3);  break;
            case 4 : return(score4);  break;
            case 5 : return(score5);  break;
            case 6 : return(score6);  break;
            default: Alert("Invalid score_type!");
         } 
      }
      
      //Get first forward trade
      if(split_type == "ratio"){
         firstftrade = int(OrdersHistoryTotal()*back_fore_ratio);
      }
      else if(split_type == "date"){
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
      }
      else{firstftrade = 0;}
      
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
      if(bnum_trades!=0){bexpected_payoff = bprofit/bnum_trades;}
      if(num_trades>=num_trades_thresh){
         if(bprofit>0){bscore0 = bsharpe;}
         if(bprofit>0){bscore1 = bsharpe*bnum_trades;}
         if(bprofit>0){bscore2 = bsharpe*bsharpe*bnum_trades;}
         if(bprofit>0){bscore3 = bsharpe*bprofit*bnum_trades;}
         if(bprofit>0){bscore4 = bsharpe*bprofit_factor*bnum_trades*bnum_trades;}
         if(bprofit>0){bscore5 = bsortino*bnum_trades;}
         if(bprofit>0){bscore6 = bsortino*bsortino*bnum_trades;}
      }
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
      if(fnum_trades!=0){fexpected_payoff = fprofit/fnum_trades;}
      if(num_trades>=num_trades_thresh){
         if(fprofit>0){fscore0 = fsharpe;}
         if(fprofit>0){fscore1 = fsharpe*fnum_trades;}
         if(fprofit>0){fscore2 = fsharpe*fsharpe*fnum_trades;}
         if(fprofit>0){fscore3 = fsharpe*fprofit*fnum_trades;}
         if(fprofit>0){fscore4 = fsharpe*fprofit_factor*fnum_trades*fnum_trades;}
         if(fprofit>0){fscore5 = fsortino*fnum_trades;}
         if(fprofit>0){fscore6 = fsortino*fsortino*fnum_trades;}
      }
      
      if(bprofit_factor>=prof_factr_thresh
         &&brecovery_factor>=recov_factr_thresh
         &&bsharpe>=sharpe_thresh
         &&num_trades>=num_trades_thresh){
         //Write to ffffile
         int b = 0;
         
         string file_name = file_nameish+"_"+string(Symbol())+"_AlphaSympleSystem.csv";
         b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");
         if(b==-1){
            Alert("File didn't open");
            Alert("Error code: ",GetLastError());
         }
         else{
            FileSeek(b,0,SEEK_END);
            FileWrite(b,DoubleToStr(bprofit,2),DoubleToStr(bgross_profit,2),DoubleToStr(bgross_loss,2),
                      bnum_trades,bnum_long_trades,bnum_short_trades,
                      DoubleToStr(bprofit_factor,2),DoubleToStr(bexpected_payoff,2),DoubleToStr(brecovery_factor,2),
                      DoubleToStr(bdrawdown_dol,2),DoubleToStr(bdrawdown_pct,3),
                      DoubleToStr(bsharpe,3),DoubleToStr(bsortino,3),
                      DoubleToStr(bscore0,2),DoubleToStr(bscore1,2),
                      DoubleToStr(bscore2,2),DoubleToStr(bscore3,2),
                      DoubleToStr(bscore4,2),DoubleToStr(bscore5,2),
                      DoubleToStr(bscore6,2),
                      DoubleToStr(fprofit,2),
                      num_trades,
                      firstftrade,
                      StartHour,TakeProfit,StopLoss,file_name);
            FileClose(b);
            Alert("Written to File");
         }
      }
      
      switch(score_type){
            case 0 : return(score0);  break;
            case 1 : return(score1);  break;
            case 2 : return(score2);  break;
            case 3 : return(score3);  break;
            case 4 : return(score4);  break;
            case 5 : return(score5);  break;
            case 6 : return(score6);  break;
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