int OnInit(){
    return(INIT_SUCCEEDED);
}

void OnDeInit(const int reason){
}

void OnTick(){
    static datetime timestamp;
    datetime time = iTime (_Symbol,PERIOD_CURRENT,0);
    if (timestamp != time){
        timestamp = time;

        double slowMaCurrent = iMA(_Symbol, PERIOD_CURRENT, 9, 0, MODE_EMA, PRICE_CLOSE, 0);
        double slowMaPrevious = iMA(_Symbol, PERIOD_CURRENT, 9, 0, MODE_EMA, PRICE_CLOSE, 1);

        double fastMaCurrent = iMA(_Symbol, PERIOD_CURRENT, 4, 0, MODE_EMA, PRICE_CLOSE, 0);
        double fastMaPrevious = iMA(_Symbol, PERIOD_CURRENT, 4, 0, MODE_EMA, PRICE_CLOSE, 1);

        // Declare ticket variable once outside both if blocks
        int ticket = -1;

        if(fastMaCurrent > slowMaCurrent && fastMaPrevious < slowMaPrevious){
            Print("Trigger BUY");
            double ask = MarketInfo(_Symbol, MODE_ASK);
            double slBuy = ask - 42 * MarketInfo(_Symbol, MODE_POINT);
            double tpBuy = ask + 69 * MarketInfo(_Symbol, MODE_POINT);

            ticket = OrderSend(_Symbol, OP_BUY, 0.1, ask, 3, slBuy, tpBuy, "TestC", 0, 0, clrNONE);
            if(ticket < 0) {
                Print("Error opening BUY order: ", GetLastError());
            } else {
                Print("BUY order opened successfully. Ticket: ", ticket);
            }
        }

        if(fastMaCurrent < slowMaCurrent && fastMaPrevious > slowMaPrevious){
            Print("Trigger SELL");
            double bid = MarketInfo(_Symbol, MODE_BID);
            double slSell = bid + 42 * MarketInfo(_Symbol, MODE_POINT);
            double tpSell = bid - 69 * MarketInfo(_Symbol, MODE_POINT);

            ticket = OrderSend(_Symbol, OP_SELL, 0.1, bid, 3, slSell, tpSell, "TestC", 0, 0, clrNONE);
            if(ticket < 0) {
                Print("Error opening SELL order: ", GetLastError());
            } else {
                Print("SELL order opened successfully. Ticket: ", ticket);
            }
        }

        Comment("\nslowMaCurrent: ", slowMaCurrent,
                "\nslowMaPrevious: ", slowMaPrevious,
                "\nfastMaCurrent: ", fastMaCurrent,
                "\nfastMaPrevious: ", fastMaPrevious);
    }
}
