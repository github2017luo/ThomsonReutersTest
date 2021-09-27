function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    return [year, month, day].join('-');
}


export function digitalCheckStatusBlocked(result) {

    if(result !== null && result.Status__c === 'Blocked'){
        return false;
    }
    return true;
}

export function digitalCompetitorCheck(result) {

    if(result !== null && result.Type__c === 'Competitor'&&result.Status__c=== 'Blocked'){
        return false;
    }
    return true;
}


export{formatDate};