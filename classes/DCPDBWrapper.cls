/********************************************************************************
Class Name : DCPDBWrapper
@description :wrapper for bundle data
***************************************************************************************

Modification Details
Date             Description                                            Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBWrapper{

    /** 
    @description BundleData wrapper to hold the
    dynalic bundling varaibles like bundlename ,pricing etc...  
    */
    public class BundleData{
        
        public String bundlename;
        public String adjusttype;
        public String pricing;
        public Decimal listvalue;
        public Decimal basevalue;
        public Decimal adjustvalue;
        public Decimal count;
        public Boolean isNotNewLineItem = false;
        public Map<String,String> bundles = new Map<String,String>();
        public Map<String,Decimal> bundlecount = new Map<String,Decimal>();
        public Set<String> prdcode = new Set<String>();
        public String groupPrimaryMaterial='';
    }

}