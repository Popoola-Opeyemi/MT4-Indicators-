//+------------------------------------------------------------------+
//|                                                   RSIScanner.mq4 |
//|                                                  Opeyemi Popoola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Opeyemi Popoola"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

// ====================== USER DEFINED ===============================
string INDI_NAME="RSIScanner";
input string FontName="Calibri"; //Font Name
input int FontSize=10;  //Font Size


int GUIXOffset = 20;
int GUIYOffset = 45;

int GUIHeaderXOffset = 20;
int GUIHeaderYOffset = 0;

int GUIColOffset=100;

int ListXOffset = 10;
int ListYOffset = 15;

int ListXMultiplier = 10;
int ListYMultiplier = 15;

int TotalCurrency = 5;
// ====================== END OF USER DEFINED ===============================



input bool ShowPrice=true; 
input int ColumnHeight=10; //Max symbols per column

input bool Show1minRSIPRICE=true;
input bool Show1minSIGNAL = true;  
input bool Showalert1min=true; 

input bool Show5minRSIPRICE=true;
input bool Show5minSIGNAL = true;  
input bool Show5minAction = true;  

input bool Show15minRSIPRICE=true;
input bool Show30minSIGNAL = true;  
input bool Show30minAction = true;  




//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping      
   ChartColorSet(CHART_COLOR_BACKGROUND,clrBlack);
   ChartColorSet(CHART_COLOR_FOREGROUND,clrWhite);
   ChartColorSet(CHART_COLOR_GRID,clrNONE);
   ChartColorSet(CHART_COLOR_VOLUME,clrNONE);
   ChartColorSet(CHART_COLOR_CHART_UP,clrNONE);
   ChartColorSet(CHART_COLOR_CHART_DOWN,clrNONE);
   ChartColorSet(CHART_COLOR_CHART_LINE,clrNONE);
   ChartColorSet(CHART_COLOR_CANDLE_BULL,clrNONE);
   ChartColorSet(CHART_COLOR_CANDLE_BEAR,clrNONE);
   ChartColorSet(CHART_COLOR_BID,clrNONE);
   ChartColorSet(CHART_COLOR_ASK,clrNONE);
   ChartColorSet(CHART_COLOR_LAST,clrNONE);
   ChartColorSet(CHART_COLOR_STOP_LEVEL,clrNONE);
   ChartModeSet(CHART_LINE);
//---
   EventSetTimer(1);

   DrawHeader();
   
   DrawScanner();

   return(INIT_SUCCEEDED);
  }


int deinit()
  {
   ObjectsDeleteAll(ChartID(),INDI_NAME);
   return(0);
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

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
//---
   
  //  Print("VALUE ", SymbolsTotal(true));
   DrawScanner();
   
  }
//+------------------------------------------------------------------+

void DrawScanner(){
  for(int x=0; x<TotalCurrency; x++){
    DrawSymbol(SymbolName(x,true),x);
  }
}

void DrawSymbol(string symbolName,int symbolIdx)
  {
   int yMult = (int)fmod(symbolIdx, ColumnHeight);
   int xMult = (symbolIdx/ColumnHeight);
   int x= (GUIXOffset+GUIHeaderXOffset) + (NumVisibleColumns()*GUIColOffset)*xMult;
   int y= GUIYOffset+ListYOffset + ListYMultiplier * yMult;
   int colOffset=GUIColOffset;

   DrawSymbolColumn(symbolName,x,y,symbolName,FontSize,FontName);

   if(ShowPrice)
      DrawPriceColumn(symbolName,x+=colOffset,y,symbolName,FontSize,FontName);
  }



void DrawHeader(){
   string objName="Header";
   int numColumns=(TotalCurrency/ColumnHeight)+1;
   int i=0;
   do
   {
      int x=(GUIXOffset+GUIHeaderXOffset)+(NumVisibleColumns()*GUIColOffset)*i;
      int y=GUIYOffset+GUIHeaderYOffset;
      string n=IntegerToString(i);


      DrawLabel(objName+"name"+n,x,y,"Name",FontSize,FontName,clrWhite,"Name");
      DrawHorizontalLine(objName+"namehline"+n,x,y,15);

      DrawLabel(objName+"price"+n,x+=GUIColOffset,y,"Price",FontSize,FontName,clrWhite,"Price");
      DrawHorizontalLine(objName+"pricehline"+n,x,y,15);

      if (Show1minRSIPRICE){
        DrawLabel(objName+"RSI (1MIN)"+n,x+=GUIColOffset,y,"RSI (1MIN)",FontSize,FontName,clrWhite,"RSI (1MIN)");
        DrawHorizontalLine(objName+"1MIN_RSIline"+n,x,y,15);
      }

      if (Show1minSIGNAL){
        DrawLabel(objName+"RSI (1MIN) SIGNAL"+n,x+=GUIColOffset,y,"1MIN SIGNAL",FontSize,FontName,clrWhite,"RSI (1MIN) SIGNAL");
        DrawHorizontalLine(objName+"1MIN_RSIline_SIGNAL"+n,x,y,15);
      }

      if (Show5minRSIPRICE){
        DrawLabel(objName+"RSI (5MIN)"+n,x+=GUIColOffset,y,"RSI (5MIN)",FontSize,FontName,clrWhite,"RSI (5MIN)");
        DrawHorizontalLine(objName+"5MIN_RSIline"+n,x,y,15);

      }

      if (Show30minSIGNAL){
        DrawLabel(objName+"RSI (15MIN)"+n,x+=GUIColOffset,y,"15MIN SIGNAL",FontSize,FontName,clrWhite,"RSI (15MIN)");
        DrawHorizontalLine(objName+"15MIN_RSIline"+n,x,y,15);
      }
      Print("here ",i);
      i++;
   }
   while(i<numColumns);

}


int NumVisibleColumns(){
   int x=1;
   if (ShowPrice){ x++; }
   if (Show1minRSIPRICE){ x++; }
   if (Show1minSIGNAL){ x++; }
   if (Show5minRSIPRICE){ x++; }
   if (Show5minSIGNAL){ x++; }
   return x;
  }

void DrawLabel(string name,int x,int y,string label,int size=9,string font="Arial",color clr=DimGray,string tooltip=""){
   name=INDI_NAME+":"+name;
   ObjectDelete(name);
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,label,size,font,clr);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,tooltip);
  }

void DrawHorizontalLine(string objName,int x,int y,int length=250){
   string line;
   for(int i=0;i<length;i++)
      line += "_";

   DrawLabel(objName+"1",x,y,line,FontSize,FontName,clrWhite,"");
}

bool ChartColorSet(int prop_id,const color clr,const long chart_ID=0){
  //--- reset the error value
   ResetLastError();
  //--- set the chart background color
  if(!ChartSetInteger(chart_ID,prop_id,clr)){
      //--- display the error message in Experts journal
    Print(__FUNCTION__+", Error Code = ",GetLastError());
    return(false);
   }
//--- successful execution
  return(true);
}

//+------------------------------------------------------------------+
//| Set chart display type (candlesticks, bars or                    |
//| line).                                                           |
//+------------------------------------------------------------------+
bool ChartModeSet(const long value,const long chart_ID=0){
  //--- reset the error value
   ResetLastError();
  //--- set property value
   if(!ChartSetInteger(chart_ID,CHART_MODE,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }

  bool TrendCreate(const long            chart_ID=0,        // chart's ID
                  const string           name="TrendLine",  // line name
                  const int              sub_window=0,      // subwindow index
                  datetime               time1=0,           // first point time
                  double                 price1=0,          // first point price
                  datetime               time2=0,           // second point time
                  double                 price2=0,          // second point price
                  const color            clr=clrRed,        // line color
                  const ENUM_LINE_STYLE  style=STYLE_SOLID, // line style
                  const int              width=1,           // line width
                  const bool             back=false,        // in the background
                  const bool             selection=true,    // highlight to move
                  const bool             ray_right=false,   // line's continuation to the right
                  const bool             hidden=true,       // hidden in the object list
                  const long             z_order=0)         // priority for mouse click
{
//--- set anchor points' coordinates if they are not set
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a trend line by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
}

void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                            datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, it is equal to the first point's one
   if(!price2)
      price2=price1;
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawPriceColumn(string symbolName,int x,int y,string text,int fontSize=8,string fontName="Calibri")
  {
   int digits=(int)MarketInfo(symbolName,MODE_DIGITS);
   double vAsk=NormalizeDouble(MarketInfo(symbolName,MODE_ASK),digits);
   double vBid=NormalizeDouble(MarketInfo(symbolName,MODE_BID),digits);
   double vSpread=NormalizeDouble(MarketInfo(symbolName,MODE_SPREAD),digits);
   string tooltip=symbolName+"\n.: Price :.\nAsk: "+(string)vAsk+"\nBid: "+(string)vBid+"\nSpread: "+(string)vSpread;
   DrawLabel("price_"+symbolName,x,y,(string)vBid+":"+ IntegerToString(x),fontSize,fontName,clrWhite,tooltip);
  }

  //+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawSymbolColumn(string symbolName,int x,int y,string text,int fontSize=8,string fontName="Calibri")
  {
   DrawLabel("lbl_"+symbolName,x,y,text,fontSize,fontName,clrWhite,symbolName);
  }
//+------------------------------------------------------------------+