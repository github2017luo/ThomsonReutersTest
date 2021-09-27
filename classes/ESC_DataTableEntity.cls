public with sharing class ESC_DataTableEntity {
  public string ESC_processing{ get; set;} 
  public string ESC_search    { get; set;}
  public string ESC_lengthMenu{ get; set;}
  public string ESC_info{ get; set;}
  public string ESC_infoEmpty { get; set;}
  public string ESC_infoFiltered    { get; set;}
  public string ESC_infoPostFix     { get; set;}
  public string ESC_loadingRecords  { get; set;}
  public string ESC_zeroRecords     { get; set;}
  public string ESC_emptyTable{ get; set;}
  public string ESC_paginateFirst   { get; set;}
  public string ESC_paginatePrevious{ get; set;}
  public string ESC_paginateNext    { get; set;}
  public string ESC_paginateLast    { get; set;}
  public string ESC_sortAscending   { get; set;}
  public string ESC_sortDescending  { get; set;}

  public ESC_DataTableEntity(){
    ESC_processing     = label.ESC_processing;
    ESC_search   = label.ESC_search;
    ESC_lengthMenu   = label.ESC_lengthMenu;
    ESC_info   = label.ESC_info;
    ESC_infoEmpty   = label.ESC_infoEmpty;
    ESC_infoFiltered   = label.ESC_infoFiltered;
    ESC_infoPostFix   = '';
    ESC_loadingRecords   = label.ESC_loadingRecords;
    ESC_zeroRecords   = label.ESC_zeroRecords;
    ESC_emptyTable   = label.ESC_emptyTable;
    ESC_paginateFirst   = label.ESC_paginateFirst;
    ESC_paginatePrevious   = label.ESC_paginatePrevious;
    ESC_paginateNext   = label.ESC_paginateNext;
    ESC_paginateLast   = label.ESC_paginateLast;
    ESC_sortAscending   = label.ESC_sortAscending;
    ESC_sortDescending   = label.ESC_sortDescending;

  }

  public static string getLabelValue(string customLabelName){

    Component.Apex.OutputText output = new Component.Apex.OutputText();
    output.expressions.value = '{!$Label.' + customLabelName + '}';
    return String.valueOf(output.value);

  }}