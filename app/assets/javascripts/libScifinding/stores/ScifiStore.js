import alt from 'components/alt';
import ElementActions from 'components/actions/ElementActions';
import ScifiActions from '../actions/ScifiActions';
import UIStore from 'components/stores/UIStore';
import ElementStore from 'components/stores/ElementStore';

class ScifiStore {
  constructor() {
    this.state = {
      links: [],
      lastLink: {
        answerLink: null,
        hitCount:  null,
        elementId: null,
        elementTitle:   null ,
        elementType: null,
        status: null,
        searchType:  null,
        svgPath: null,
        key: null,
      },

    };

    this.bindListeners({
      handleUpdateScifi71: [ScifiActions.updateSf71,ScifiActions.updateSf72],
      handleUpdateSample: ElementActions.updateSample,
    })
  }




  handleUpdateScifi71(sf71Resp) {
    let timeNow=function(){return new Date().getTime();};
    let lastLink = {key: timeNow(),status:sf71Resp.status, elementTitle: sf71Resp.elementTitle ,hitCount: sf71Resp.info, answerLink: sf71Resp.links, searchType:sf71Resp.searchType, elementId:sf71Resp.elementId, svgPath: sf71Resp.svgPath, elementType: sf71Resp.elementType};
    //  ({...this.state.lastLink} ={...lastLink});
    this.setState({links: [lastLink,...this.state.links],lastLink: lastLink});//this.state.links.unshift(lastLink);
    this.handleRefreshElements(sf71Resp.elementType);
  }

  handleUpdateScifi72(sf72Resp) {
    this.handleUpdateScifi71(sf72Resp);
  }

  handleUpdateSample(){
    ({...this.state.lastLink} ={
        answerLink: null,
        hitCount:  null,
        elementId: null,
        elementTitle:   null ,
        elementType: null,
        status: null,
        searchType:  null,
        svgPath: null,
        key: null,
        })
  }

  handleRefreshElements(type){

    this.waitFor(UIStore.dispatchToken);
    let uiState = UIStore.getState();
    let page = uiState[type].page;
    let elementState = ElementStore.getState();
    elementState.elements[type+'s'].page = page;
    let currentSearchSelection = uiState.currentSearchSelection;

    // TODO if page changed -> fetch
    // if there is a currentSearchSelection we have to execute the respective action
    if(currentSearchSelection != null) {
      ElementActions.fetchBasedOnSearchSelectionAndCollection(currentSearchSelection, uiState.currentCollection.id, page);
    } else {
      switch (type) {
        case 'sample':
          ElementActions.fetchSamplesByCollectionId(uiState.currentCollection.id, {page: page, per_page: uiState.number_of_results});
          break;
        case 'reaction':
          ElementActions.fetchReactionsByCollectionId(uiState.currentCollection.id, {page: page, per_page: uiState.number_of_results});
          break;
        case 'wellplate':
          ElementActions.fetchWellplatesByCollectionId(uiState.currentCollection.id, {page: page, per_page: uiState.number_of_results});
          break;
        case 'screen':
          ElementActions.fetchScreensByCollectionId(uiState.currentCollection.id, {page: page, per_page: uiState.number_of_results});
          break;
      }
    }


  }



}

export default alt.createStore(ScifiStore, 'ScifiStore');
