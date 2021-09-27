/***********************************************************************************************
Purpose      : Format total Price/list price  for renewal notice templates
Developed By : TCS Offshore-Renewal Notice
Date         : 07/20/2016
Changed Log  :
************************************************************************************************/
public  class RenewalTemplatePriceFormat{
    public decimal price {get;set;}
    public String s='';
    public Boolean isUSD = true;//Mrinmoy Added to fix the issue SFD-1242
    public String getTotalPrice()
    {  
        try
        {      
            String amount;
            amount = string.valueof(price.format());
            System.debug('The value is amount: ' +amount);
            if(string.valueof(price.format()).right(3).contains('.')){
                String fAmaount=amount.substringBefore('.');
                String lAmaount=amount.substringAfter('.'); 
                if(lAmaount.length()==1){
                    lAmaount=lAmaount+'0';            
                }           
                fAmaount=fAmaount.replaceAll(',','.');
                amount=fAmaount+','+lAmaount;
                System.debug('The value is amount after formatting: ' +amount);            
            }
            else if(string.valueof(price.format()).right(3).contains(',')){
                isUSD = false;
                String fAmaount=amount.substringBefore(',');
                String lAmaount=amount.substringAfter(',');
                if(lAmaount.length()==1){
                    lAmaount=lAmaount+'0';            
                }
                amount=fAmaount+','+lAmaount;
            }            
            //Mrinmoy re-arranged the code to fix the issue SFD-1242            
            else if(string.valueof(price.format()).contains('.')==false){
               if(isUSD)      
                {          
                    amount=amount.replaceAll(',','.');
                    amount=amount+',00';
                }
            }
            else{
                amount=amount+',00';
            }
            return amount;
        }
        catch(Exception e)
        {
           throw e;
        }
        
    }
}