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


void OnDeinit(const int reason){
   
   double run_profit = TesterStatistics(STAT_PROFIT);
   double best_profit = -1000.0;
   int rrab = 0;
   rrab = FileOpen("template_holder.tpl",FILE_CSV|FILE_READ|FILE_WRITE,",");
   if(rrab==-1){
      Alert("File didn't open");
      Alert("Error code: ",GetLastError());
   }
   else{
      FileSeek(rrab,0,SEEK_SET);
      best_profit = FileReadNumber(rrab);
      if(run_profit > best_profit){
         FileSeek(rrab,0,SEEK_SET);
         FileWrite(rrab,run_profit);
         Alert("Written to File");
         
         
         string template_contents = "";
         string template_header = "<chart>\nsymbol=GBPUSD\nperiod=30\nleftpos=37\ndigits=4\nscale=8\ngraph=1\nfore=1\ngrid=1\nvolume=0\nscroll=1\nshift=1\nohlc=1\naskline=0\ndays=1\ndescriptions=0\nshift_size=20\nfixed_pos=0\nwindow_left=307\nwindow_top=0\nwindow_right=614\nwindow_bottom=159\nwindow_type=1\nbackground_color=0\nforeground_color=16777215\nbarup_color=65280\nbardown_color=65280\nbullcandle_color=0\nbearcandle_color=16777215\nchartline_color=65280\nvolumes_color=3329330\ngrid_color=10061943\naskline_color=255\nstops_color=255\n";
         string template_openwindow = "\n<window>";
         string template_indicator_ma = StringFormat("\nheight=151\n<indicator>\nname=main\n</indicator>\n<indicator>\nname=Moving Average\nperiod=%i\nshift=0\nmethod=0\napply=0\ncolor=16777215\nstyle=0\nweight=3\nperiod_flags=0\nshow_data=1\n</indicator>\n",MA_Period);
         string template_closewindow = "\n</window>";
         
         StringAdd(template_contents,template_header);
         StringAdd(template_contents,template_openwindow);
         StringAdd(template_contents,template_indicator_ma);
         StringAdd(template_contents,template_closewindow);
         
         int rraa = 0;
         rraa = FileOpen("template_simple_system.tpl",FILE_CSV|FILE_READ|FILE_WRITE,",");
         if(rraa==-1){
            Alert("File didn't open");
            Alert("Error code: ",GetLastError());
         }
         else{
            FileSeek(rraa,0,SEEK_SET);
            FileWrite(rraa,template_contents);
            FileClose(rraa);
            Alert("Written to File");
         }
      }
      FileClose(rrab);
   }
}


