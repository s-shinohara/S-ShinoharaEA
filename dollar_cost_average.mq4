//+------------------------------------------------------------------+
//|                                          dollar_cost_average.mq4 |
//|                                                            sunpe |
//|                     http://highanddry55.blog3.fc2.com/           |
//+------------------------------------------------------------------+
#property copyright "sunpe"
#property link      "http://highanddry55.blog3.fc2.com/"


extern int t_start = 0;
extern int t_end = 23;
extern int price_width = 10000;
extern double budget_factor = 10000;

extern int magic = 1000;

int ticket[25];
double lots[25];

bool dup_entry = false;
bool dup_close = false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{

//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{

//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
    double price_factor = 1 - (Open[Hour() - t_start] - Bid) / (price_width * Point);
    if (t_start <= Hour() && Hour() < t_end && price_factor > 0) {
        if (Minute() == 0) {
            dup_entry = false;
        } else if (Minute() == 1 && !dup_entry) {
            double one_time_budget = AccountBalance() / (t_end - t_start) / budget_factor;
            lots[Hour()] = one_time_budget / price_factor;
            ticket[Hour()] = OrderSend(Symbol(), OP_BUY, lots[Hour()], Ask, 3, 0, 0, NULL, magic);

            dup_entry = true;
        }
    } else if (Hour() == t_end) {
        if (Minute() == 0) {
            dup_close = false;
        } else if (Minute() == 1 && !dup_close) {
            int i;
            for (i = t_start; i < t_end; i++) {
                if (ticket[i] != -1) {
                    OrderClose(ticket[i], lots[i], Bid, 3);
                }
            }
            dup_close = true;
        }
    }

//----
   return(0);
}
//+------------------------------------------------------------------+

