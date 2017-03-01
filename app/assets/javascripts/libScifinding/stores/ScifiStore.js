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
        url: null,
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
    let timeNow = () => {return new Date().getTime();}
    let lastLink = {key: timeNow(), ...sf71Resp}
    let newLinks = [ lastLink, ...this.state.links]
    this.state.links = newLinks
    this.state.lastLink = lastLink
    this.handleRefreshElements(sf71Resp.elementType);
  }

  handleUpdateScifi72(sf72Resp) {
    this.handleUpdateScifi71(sf72Resp);
  }

  handleUpdateSample(){
    ({...this.state.lastLink} ={
        url: null,
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
      }
    }

  }


}

export default alt.createStore(ScifiStore, 'ScifiStore');
