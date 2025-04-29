#include <trade/Trade.mqh>
CTrade trade;

int OnInit(){

	return(INIT_SUCCEEDED);
}

void OnDeInit(const int reason){

}

void OnTick(){

	static datetime timestamp;
	datetime time = iTime (_Symbol,PERIOD_CURRENT,0);
	if (timestamp !=time){
		timestamp = time;

		static int handleSlowMa = iMA (_Symbol,PERIOD_CURRENT,9,0,MODE_EMA,PRICE_CLOSE);
		double slowMaArray[];
		CopyBuffer(handleSlowMa,0,1,2,slowMaArray);
		ArraySetAsSeries(slowMaArray,true);

		static int handleFastMa = iMA (_Symbol,PERIOD_CURRENT,4,0,MODE_EMA,PRICE_CLOSE);
		double fastMaArray[];
		CopyBuffer(handleFastMa,0,1,2,fastMaArray);
		ArraySetAsSeries(fastMaArray,true);

		if(fastMaArray[0] > slowMaArray[0] && fastMaArray[1] < slowMaArray[1]){
			Print("Trigger");
			double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
			double sl = ask - 42 * SymbolInfoDouble(_Symbol ,SYMBOL_POINT);
			double tp = ask + 69 * SymbolInfoDouble(_Symbol ,SYMBOL_POINT);
			trade.Buy(0.1,_Symbol,ask,sl,tp,"not abuse");
		}
		if(fastMaArray[0] < slowMaArray[0] && fastMaArray[1] > slowMaArray[1]){
			Print("Trigger");
			double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
			double sl = bid + 42 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
			double tp = bid - 69 * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
			trade.Sell(0.1,_Symbol,bid,sl,tp,"not abuse");
		}

		Comment("\nslowMaArray[0]: ",slowMaArray[0],
			     "\nslowMaArray[1]: ",slowMaArray[1],
			     "\nfastMaArray[0]: ",fastMaArray[0],
			     "\nfastMaArray[1]: ",fastMaArray[1]);
	}
}