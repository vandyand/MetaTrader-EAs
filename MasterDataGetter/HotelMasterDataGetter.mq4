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
//HotelMasterDataGetter is copied from HotelDiscreteModelMaker. Back and fore tests are
//split into back, fore and verify tests. Statistics for each of these periods is written
//to file. Also, functionality for rolling timeframes was added so multiple time periods can
//be backtested in one strategy tester run.
//
//------------------------------------------------------------------------------------------






extern int Long_Back_1;
extern int Long_Back_2;
extern int Short_Back_1;
extern int Short_Back_2;
extern int Open_Bars;//empty variable here kept for analysis stuff with python

extern datetime now;

extern int go_back = 0;

extern int back_interval_proportion = 3;
extern int fore_interval_proportion = 1;
extern int verify_interval_proportion = 1;




extern bool write_to_file = false;
extern double Lots = 0.01;
extern bool get_random_results = false;
extern bool only_positive_results = false;




int ticket;
int Magic = 200;
bool LongCond = false;
bool ShortCond = false;
bool ExitLongCond = false;
bool ExitShortCond = false;

bool first_pass = true;
bool first_fore_pass = false;
bool first_verify_pass = false;
bool back = false;
bool fore = false;
bool verify = false;
datetime cur_test_time = TimeLocal();

datetime cur_time = TimeCurrent();
string file_name = string(TimeYear(cur_time))+
                   string(TimeMonth(cur_time))+
                   string(TimeDay(cur_time))+
                   string(TimeHour(cur_time))+
                   string(TimeMinute(cur_time))+
                   string(TimeSeconds(cur_time))+
                   "-TestingData.csv";

datetime back_split = now - 60*60*24*(back_interval_proportion+fore_interval_proportion+verify_interval_proportion+go_back);
datetime fore_split = now - 60*60*24*(fore_interval_proportion+verify_interval_proportion+go_back);
datetime verify_split = now - 60*60*24*(verify_interval_proportion+go_back);
datetime cutoff_split = now - 60*60*24*go_back;

int oneshot1 = 0;
int oneshot2 = 0;
int oneshot3 = 0;
int oneshot4 = 0;
int oneshot5 = 0;

void OnTick(){
   cur_test_time = TimeCurrent();
   
   if(cur_test_time >= back_split && cur_test_time < fore_split){
      back = true;
      fore = false;
      verify = false;
      if(oneshot1 == 0){
         Print("Back turns true");
         oneshot1++;
      }   
   }
   if (cur_test_time >=fore_split && cur_test_time < verify_split){
      back = false;
      fore = true;
      verify = false;
      
      if(oneshot2 == 0){
         first_fore_pass = true;
         Print("Fore turns true");
         oneshot2++;
      }
   }
   if (cur_test_time >= verify_split && cur_test_time < cutoff_split){
      back = false;
      fore = false;
      verify = true;
      
      if(oneshot3 == 0){
         first_verify_pass = true;
         Print("Verify turns true");
         oneshot3++;
      } 
   }
   if (cur_test_time >= cutoff_split){
      back = false;
      fore = false;
      verify = false;
      if(oneshot4 == 0){
         Print("Verify turns false");
         oneshot4++;
      } 
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
      
      if((back||fore||verify)&&LongCond&&!ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
      }
      
      if((back||fore||verify)&&!LongCond&&ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);
      }
      
      bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
      int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
      
      
      if(CheckOpenOrders()&&(LongCond==ShortCond||first_fore_pass||first_verify_pass||(!back&&!fore&&!verify))){
         if(type==0){bool closer = OrderClose(ticket,Lots,Bid,10,0);}
         if(type==1){bool closer = OrderClose(ticket,Lots,Ask,10,0);}
      }
   }
   
   if(first_pass){first_pass=false;}
   if(first_fore_pass){first_fore_pass=false;}
   if(first_verify_pass){first_verify_pass=false;}
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
int firstvtrade = 0;

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

double vprofit = 0;
double vgross_profit = 0;
double vgross_loss = 0;
double vnum_trades = 0;
double vnum_long_trades = 0;
double vnum_short_trades = 0;
double vprofit_factor = 0;
double vexpected_payoff = 0;
double vdrawdown_dol = 0;
double vdrawdown_pct = 0;
double vrecovery_factor = 0;
double vsharpe = 0;
double vsortino = 0;

double whole_counter = 0;
double bcounter = 0;
double fcounter = 0;

double OnTester(){

   //Calculate overall statistics (do I need this...?)
   pass = 0;
   double res54 = get_performance_stats(0,0, "none", sharpe, sortino,
                                        profit, gross_profit, gross_loss,
                                        drawdown_dol, drawdown_pct,
                                        num_long_trades, num_short_trades,num_trades);
   if(gross_loss!=0){profit_factor = gross_profit/gross_loss * -1;}
   else{profit_factor = num_trades;}
   if(drawdown_dol!=0){recovery_factor = profit/drawdown_dol;}
   else{recovery_factor = num_trades;}
   if(num_trades!=0){expected_payoff = profit/num_trades;}
   
   //Get first forward and verify trades
   bool foundf = false;
   bool foundv = false;
   
   for(int i = 0; i <= OrdersHistoryTotal(); i++){
      bool res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderOpenTime()>fore_split&&foundf==false){
         firstftrade = i+1;
         Print("firstftrade = "+string(firstftrade));
         foundf = true;
      }
      if(OrderOpenTime()>verify_split&&foundv==false){
         firstvtrade = i+1;
         Print("firstvtrade = "+string(firstvtrade));
         foundv = true;
      }
      if(foundf&&foundv){
         i=OrdersHistoryTotal();
      }      
   }
   if(!foundf){firstftrade = OrdersHistoryTotal()-1;}
   if(!foundv){firstvtrade = OrdersHistoryTotal()-1;}

   
   //calculate backtest statistics   
   double res49 = get_performance_stats(firstftrade, firstvtrade, "back", bsharpe, bsortino,
                                        bprofit, bgross_profit, bgross_loss,
                                        bdrawdown_dol, bdrawdown_pct,
                                        bnum_long_trades, bnum_short_trades, bnum_trades);
   if(bgross_loss!=0){bprofit_factor = bgross_profit/bgross_loss * -1;}
   else{bprofit_factor = bnum_trades;}
   if(bdrawdown_dol!=0){brecovery_factor = bprofit/bdrawdown_dol;}
   else{brecovery_factor = bnum_trades;}
   if(bnum_trades!=0){bexpected_payoff = bprofit/bnum_trades;}
   
   if(write_to_file==false){
      if(get_random_results){return(0);}
      else{return(0);}
   }
   
   
   //Calculate foretest statistics
   double res66 = get_performance_stats(firstftrade, firstvtrade, "fore", fsharpe, fsortino, 
                                        fprofit, fgross_profit, fgross_loss,
                                        fdrawdown_dol,fdrawdown_pct,
                                        fnum_long_trades, fnum_short_trades,fnum_trades);
   if(fgross_loss!=0){fprofit_factor = fgross_profit/fgross_loss * -1;}
   else{fprofit_factor = fnum_trades;}
   if(fdrawdown_dol!=0){frecovery_factor = fprofit/fdrawdown_dol;}
   else{frecovery_factor = fnum_trades;}
   if(fnum_trades!=0){fexpected_payoff = fprofit/fnum_trades;}
   
   
   //Calculate verify test statistics
   double res67 = get_performance_stats(firstftrade, firstvtrade, "verify", vsharpe, vsortino, 
                                        vprofit, vgross_profit, vgross_loss,
                                        vdrawdown_dol,vdrawdown_pct,
                                        vnum_long_trades, vnum_short_trades,vnum_trades);
   if(vgross_loss!=0){vprofit_factor = vgross_profit/vgross_loss * -1;}
   else{vprofit_factor = vnum_trades;}
   if(vdrawdown_dol!=0){vrecovery_factor = vprofit/vdrawdown_dol;}
   else{vrecovery_factor = vnum_trades;}
   if(vnum_trades!=0){vexpected_payoff = vprofit/vnum_trades;}
   
   
   if(!only_positive_results || (only_positive_results && (bprofit+fprofit)>0))
   {
      //Write to ffffile
      int b = 0;
      
      b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");
      FileSeek(b,0,SEEK_SET);
      string head = FileReadString(b,5);
      FileClose(b);
      
      
      //Write column headers
      if(head=="")
      {
         b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");
         if(b==-1)
         {
            Alert("File didn't open");
            Alert("Error code: ",GetLastError());
         }
         else
         {
            FileSeek(b,0,SEEK_END);
            FileWrite(b,
                      "profit","gross_profit","gross_loss","num_trades","num_long_trades","num_short_trades",
                      "profit_factor","expected_payoff","recovery_factor","drawdown_dol","drawdown_pct",
                      "sharpe","sortino",
                      "bprofit","bgross_profit","bgross_loss","bnum_trades","bnum_long_trades","bnum_short_trades",
                      "bprofit_factor","bexpected_payoff","brecovery_factor","bdrawdown_dol","bdrawdown_pct",
                      "bsharpe","bsortino",
                      "fprofit","fgross_profit","fgross_loss","fnum_trades","fnum_long_trades","fnum_short_trades",
                      "fprofit_factor","fexpected_payoff","frecovery_factor","fdrawdown_dol","fdrawdown_pct",
                      "fsharpe","fsortino",
                      "vprofit","vgross_profit","vgross_loss","vnum_trades","vnum_long_trades","vnum_short_trades",
                      "vprofit_factor","vexpected_payoff","vrecovery_factor","vdrawdown_dol","vdrawdown_pct",
                      "vsharpe","vsortino",
                      "Long_Back_1","Long_Back_2","Short_Back_1","Short_Back_2","go_back",
                      "back_split","fore_split","verify_split","cutoff_split"
                      );
            FileClose(b);
         }
      }
      
      //Write file contents
      b = FileOpen(file_name,FILE_CSV|FILE_READ|FILE_WRITE,",");   
      if(b==-1)
      {
         Alert("File didn't open");
         Alert("Error code: ",GetLastError());
      }
      else
      {
         
         FileSeek(b,0,SEEK_END);
         FileWrite(b,
                   DoubleToStr(profit,2),DoubleToStr(gross_profit,2),DoubleToStr(gross_loss,2),
                   num_trades,num_long_trades,num_short_trades,
                   DoubleToStr(profit_factor,2),DoubleToStr(expected_payoff,2),DoubleToStr(recovery_factor,2),
                   DoubleToStr(drawdown_dol,2),DoubleToStr(drawdown_pct,3),
                   DoubleToStr(sharpe,4),DoubleToStr(sortino,4),
                   
                   DoubleToStr(bprofit,2),DoubleToStr(bgross_profit,2),DoubleToStr(bgross_loss,2),
                   bnum_trades,bnum_long_trades,bnum_short_trades,
                   DoubleToStr(bprofit_factor,2),DoubleToStr(bexpected_payoff,2),DoubleToStr(brecovery_factor,2),
                   DoubleToStr(bdrawdown_dol,2),DoubleToStr(bdrawdown_pct,3),
                   DoubleToStr(bsharpe,4),DoubleToStr(bsortino,4),
                   
                   DoubleToStr(fprofit,2),DoubleToStr(fgross_profit,2),DoubleToStr(fgross_loss,2),
                   fnum_trades,fnum_long_trades,fnum_short_trades,
                   DoubleToStr(fprofit_factor,2),DoubleToStr(fexpected_payoff,2),DoubleToStr(frecovery_factor,2),
                   DoubleToStr(fdrawdown_dol,2),DoubleToStr(fdrawdown_pct,3),
                   DoubleToStr(fsharpe,4),DoubleToStr(fsortino,4),
                   
                   DoubleToStr(vprofit,2),DoubleToStr(vgross_profit,2),DoubleToStr(vgross_loss,2),
                   vnum_trades,vnum_long_trades,vnum_short_trades,
                   DoubleToStr(vprofit_factor,2),DoubleToStr(vexpected_payoff,2),DoubleToStr(vrecovery_factor,2),
                   DoubleToStr(vdrawdown_dol,2),DoubleToStr(vdrawdown_pct,3),
                   DoubleToStr(vsharpe,4),DoubleToStr(vsortino,4),
                   
                   Long_Back_1,Long_Back_2,Short_Back_1,Short_Back_2,go_back,
                   back_split,fore_split,verify_split,cutoff_split
                   
                   );
         FileClose(b);
         Alert("Written to File");
      }
   }
   if(get_random_results){return(0);}
   else{return(0);}
   return(0);
}

double get_performance_stats(int firstftrade_, int firstvtrade_, string bfv, double& shsharpe, double& ssortino,
                             double& pprofit, double& ggross_profit, double& ggross_loss,
                             double& dd, double& dd_pct, double& nnum_long_trades, double& nnum_short_trades,
                             double& counterr){
   
   int num_orders = 0;
   int strt = 0;
   int end = 0;
   
   if(bfv=="verify"){
      strt = OrdersHistoryTotal();
      end = firstvtrade_-1;
   }
   else if(bfv=="fore"){
      strt = firstvtrade_-1;
      end = firstftrade_-1;
   }
   else if(bfv=="back"){
      strt = firstftrade_-1;
      end = 0;
   }
   else if(bfv=="none"){
      strt = OrdersHistoryTotal();
      end = 0;
   }
   else{
      return(-1);
   }
   num_orders = strt - end;
   
   
   double local_drawdown = 0;
   double max_drawdown = 0;
   double max_drawdown_pct = 0;
   double high_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double local_low_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double curr_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   
   for(int i = strt-1; i > end-1; --i){
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
   
   for(int i = strt-1; i > end-1; --i){
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
   for(int i = strt-1; i > end-1; --i){
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