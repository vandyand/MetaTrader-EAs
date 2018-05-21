
import os
import calendar
import time
from datetime import datetime, timedelta

os.chdir('C:\\Program Files (x86)\\OANDA - MetaTrader')
os.getcwd()

# Editable parameters
##########################################################
#
#
# Meta Parameters
num_iterations = 200 # Number of time_periods to go back 
back_step_size = 1 #How many work days to go back per iteration
back_steps = 10 # For determining start date (2 * 5 work days (step_size) = 10 work days = 2 weeks)
fore_steps = 1 # For determining start and split date
#
start_year = 2018
start_month = 5
start_day = 18
#
# EA Parameters (for EchoDiscreteModelMaker)
lookback_time_days = 4 #For opening and closing trades parameters
holding_time_days = 1
timeframe = 15 #minutes
Chart_Timeframe = 'M15'
optimization_score_num = 0
file_name_prefix_vers = 5000
#
#
##########################################################



# Setting up computer file parameters
date_list = [datetime.strftime(datetime(start_year,start_month,start_day) - timedelta(days=x),'%Y.%m.%d') for x in range(10000) if (datetime(start_year,start_month,start_day)-timedelta(days=x)).weekday() not in [0,6] ]
start_dates = [date_list[(x+back_steps+fore_steps)*back_step_size] for x in range(num_iterations)]
split_dates = [date_list[(x+fore_steps)*back_step_size] for x in range(num_iterations)]
end_dates = [date_list[x*back_step_size] for x in range(num_iterations)]
split_datetimes = [calendar.timegm(time.strptime(x,'%Y.%m.%d')) for x in split_dates]
file_nameishes = ['{}'.format(x+1+file_name_prefix_vers) for x in range(num_iterations)]
param_file_names = ['iter{}_params_file.txt'.format(x+1) for x in range(num_iterations)]
set_file_names = ['iter{}_set_file.set'.format(x+1) for x in range(num_iterations)]


# EA computer parameters
bars_in_lookback = int(lookback_time_days*24*60/timeframe) # days * hours/day * bars/hour
bars_in_holding = int(holding_time_days*24*60/timeframe)

Long_Back_1_Start = 0
Long_Back_1_Step = 1
Long_Back_1_End = bars_in_lookback
Long_Back_2_Start = 0
Long_Back_2_Step = 1
Long_Back_2_End = bars_in_lookback
Short_Back_1_Start = 0
Short_Back_1_Step = 1
Short_Back_1_End = bars_in_lookback
Short_Back_2_Start = 0
Short_Back_2_Step = 1
Short_Back_2_End = bars_in_lookback
Open_Bars_Start = 1
Open_Bars_Step = 1
Open_Bars_End = bars_in_holding
Lots_Value = 0.01

for i in range(num_iterations):
      
    
    # Set file creation
    os.chdir('C:\\Program Files (x86)\\OANDA - MetaTrader\\tester')

    split_datetime = split_datetimes[i]
    file_nameish = file_nameishes[i]
    
    
    set_file_content = '''Long_Back_1=0
Long_Back_1,F=1
Long_Back_1,1={}
Long_Back_1,2={}
Long_Back_1,3={}
Long_Back_2=0
Long_Back_2,F=1
Long_Back_2,1={}
Long_Back_2,2={}
Long_Back_2,3={}
Short_Back_1=0
Short_Back_1,F=1
Short_Back_1,1={}
Short_Back_1,2={}
Short_Back_1,3={}
Short_Back_2=0
Short_Back_2,F=1
Short_Back_2,1={}
Short_Back_2,2={}
Short_Back_2,3={}
Open_Bars=0
Open_Bars,F=1
Open_Bars,1={}
Open_Bars,2={}
Open_Bars,3={}
prof_factr_thresh=1.00000000
prof_factr_thresh,F=0
prof_factr_thresh,1=0.00000000
prof_factr_thresh,2=0.00000000
prof_factr_thresh,3=0.00000000
recov_factr_thresh=0.00000000
recov_factr_thresh,F=0
recov_factr_thresh,1=0.00000000
recov_factr_thresh,2=0.00000000
recov_factr_thresh,3=0.00000000
sharpe_thresh=0.00000000
sharpe_thresh,F=0
sharpe_thresh,1=0.00000000
sharpe_thresh,2=0.00000000
sharpe_thresh,3=0.00000000
score_thresh=0.00000000
score_thresh,F=0
score_thresh,1=0.00000000
score_thresh,2=0.00000000
score_thresh,3=0.00000000
num_trades_thresh=1
num_trades_thresh,F=0
num_trades_thresh,1=1
num_trades_thresh,2=0
num_trades_thresh,3=0
split_datetime={}
split_datetime,F=0
split_datetime,1=0
split_datetime,2=0
split_datetime,3=0
write_to_file=1
write_to_file,F=0
write_to_file,1=0
write_to_file,2=1
write_to_file,3=1
file_name_prefix={}
file_name_prefix,F=0
file_name_prefix,1=0
file_name_prefix,2=0
file_name_prefix,3=0
score_type={}
score_type,F=0
score_type,1=0
score_type,2=0
score_type,3=0
Lots={}
Lots,F=0
Lots,1=0.00000000
Lots,2=0.00000000
Lots,3=0.00000000
'''.format(Long_Back_1_Start,Long_Back_1_Step,Long_Back_1_End,
Long_Back_2_Start,Long_Back_2_Step,Long_Back_2_End,Short_Back_1_Start,
Short_Back_1_Step,Short_Back_1_End,Short_Back_2_Start,Short_Back_2_Step,
Short_Back_2_End,Open_Bars_Start,Open_Bars_Step,Open_Bars_End,
split_datetime,file_nameish,optimization_score_num,Lots_Value)
    
    set_file_name = set_file_names[i]
    set_file = open(set_file_name,'a')
    set_file.write(set_file_content)
    set_file.close()
    
    
    # Param file creation
    start_date = start_dates[i]
    end_date = end_dates[i]
    
    param_file_content = '''; start strategy tester 
TestExpert=DiscreteModelMaker\EchoDiscreteModelMaker
TestExpertParameters={} 
TestSymbol=EURUSD 
TestPeriod={} 
TestModel=2 
TestSpread=15 
TestOptimization=true 
TestDateEnable=true 
TestFromDate={} 
TestToDate={} 
TestShutdownTerminal=true
'''.format(set_file_name,Chart_Timeframe,start_date,end_date)
    
    param_file_name = param_file_names[i]
    param_file = open(param_file_name,'a')
    param_file.write(param_file_content)
    param_file.close()
    
    
    # Batch file creation
    batch_file_content = '''terminal.exe /portable tester/{}
'''.format(param_file_name)
    
    os.chdir('C:\\Program Files (x86)\\OANDA - MetaTrader')
    
    batch_file_name = 'batch_backtests.bat'
    batch_file = open(batch_file_name, 'a')
    batch_file.write(batch_file_content)
    batch_file.close()
    
    

    
    





