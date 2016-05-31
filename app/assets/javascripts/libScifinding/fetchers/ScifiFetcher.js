import 'whatwg-fetch';

import _ from 'lodash';

export default class ScifiFetcher {


  static sf71(params) {

    let mdl = params.mdl;
    let hitCount = true;
    let searchType = params.searchType || 'exact';
    let elementId  = params.elementId;
    if (searchType == 'substructure') {searchType = 'sss';}
    let elementType = params.elementType || 'sample';
    let promise = fetch('/scifi/v1/credentials/sf71.json', {
      credentials: 'same-origin',
      method: 'post',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        hitCount:  hitCount ,
        searchType:  searchType,
        mdl: mdl,
        elementId: elementId,
        elementType: elementType,
      })
    }).then((response) => {
      return response.json()
    }).then((json) => {
    // console.log(json);
       return json;
    }).catch((errorMessage) => {
      console.log(errorMessage);
    });
   return promise;
  }

  static sf72(params) {

    let rxn = params.rxn;
    let searchType = params.searchType || 'substructure'; //or 'variable'
    let reactionId = params.elementId;
    if (searchType == 'substructure') {searchType = 'sss';}  //todo: not clear from doc if it is needed for reaction

    let promise = fetch('/scifi/v1/credentials/sf72.json', {
      credentials: 'same-origin',
      method: 'post',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({

        searchType:  searchType,
        rxn: rxn,
        elementId: reactionId,
        elementType: 'reaction' ,

      })
    }).then((response) => {
      return response.json()
    }).then((json) => {
    // console.log(json);
       return json;
    }).catch((errorMessage) => {
      console.log(errorMessage);
    });
   return promise;
  }

}
