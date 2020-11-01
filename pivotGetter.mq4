//+------------------------------------------------------------------+
//|                                                  pivotGetter.mq4 |
//|                                                  Opeyemi Popoola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Opeyemi Popoola"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   generatePoint();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


void generatePoint(){
    double Op, Hi ,Lo ,Cl;

    Op = iOpen(NULL,PERIOD_W1,1);
    Hi = iHigh(NULL,PERIOD_W1,1);
    Lo = iLow(NULL,PERIOD_W1,1);
    Cl = iClose(NULL,PERIOD_W1,1);
    
    string Symb = Symbol();

    double pp = (Hi + Lo + Cl) / 3;
        
    double r1 = (pp *2 ) - Lo;
    double r2 = pp + (Hi - Lo);
    
    double s1 = (pp *2 ) - Hi;
    double s2 =  pp - (Hi - Lo);
    
    
    //  Pivot Point 
    DrawHorizontalLine(Symb, "pivot point", clrRed, pp );
    CreateLabel("label"+DoubleToStr(pp,Digits), "PP",Symb,pp);
   
    
    //--- Resistance 

    DrawHorizontalLine(Symb, "r1", clrGreen, r1 );
    CreateLabel("label"+DoubleToStr(r1,Digits), "R1",Symb,r1);
    
    //--- SUPPORT 
  
    DrawHorizontalLine(Symb, "s1", clrBlue, s1 );
    CreateLabel("label"+DoubleToStr(s1,Digits), "S1",Symb,s1);

    Comment("Weekly Pivot "+DoubleToStr(pp,Digits)+ " High "+DoubleToStr(Hi,Digits)+ " Low "+DoubleToStr(Lo,Digits)+" Close "+DoubleToStr(Cl,Digits));
    
    }
    
    // 
  void CreateLabel(string name, string title, string symbol, double point){
      
      int x, y;
      
      bool result = ChartTimePriceToXY (0, 0, Time [0], point, x, y);
        
      ObjectCreate(name, OBJ_LABEL,0,0,0);
      
      ObjectSetText(name,title,8,"Arial",Red);
      
      ObjectSet(name, OBJPROP_CORNER, 1);
      
      ObjectSet(name, OBJPROP_XDISTANCE, 20);
      
      ObjectSet(name, OBJPROP_YDISTANCE, y);
  }

  void DrawHorizontalLine(string symb, string name, color clr, double point){

    ObjectCreate(symb, name, OBJ_HLINE, 0, 0, point);
    
    ObjectSetInteger(0, name, OBJPROP_COLOR,clr);
    
    ObjectSetInteger(0, name,OBJPROP_WIDTH,3);

  }
    