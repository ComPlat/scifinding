import alt from 'components/alt';
import ScifiFetcher from '../fetchers/ScifiFetcher';

import _ from 'lodash';

class ScifiActions {

  updateSf71(params,otherParams) {
    let _params = _.omit(params, _.isNull);
    return (dispatch)=> {
       ScifiFetcher.sf71(_params)
      .then(result => {dispatch({...result,...otherParams});})
      .catch(errorMessage => {console.log(errorMessage);});
    };
  }

  updateSf72(params,otherParams) {
    let _params = _.omit(params, _.isNull);
    return (dispatch)=> {
      ScifiFetcher.sf72(_params)
      .then(result => {dispatch({...result,...otherParams});})
      .catch(errorMessage => {console.log(errorMessage);});
    };
  }
}
export default alt.createActions(ScifiActions);
