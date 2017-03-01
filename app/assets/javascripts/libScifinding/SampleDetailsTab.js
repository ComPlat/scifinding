import React, {Component} from 'react';
import {Badge,Button, ButtonGroup, ButtonToolbar, ListGroup, ListGroupItem, Glyphicon} from 'react-bootstrap';
import ScifiStore from './stores/ScifiStore';
import ScifiQueryButton from './ScifiQueryButton';
import ScifiLinkButton from './ScifiLinkButton';
import ElementStore from 'components/stores/ElementStore';
import ElementActions from 'components/actions/ElementActions';


import SVG from 'react-inlinesvg';
import classnames from 'classnames';

export default class SampleDetailsTabHook extends Component {

  constructor(props) {
    super(props)
    const scifiStoreState = ScifiStore.getState()
    this.state = scifiStoreState

    this.onChange = this.onChange.bind(this)
  }

  componentDidMount() {
    ScifiStore.listen(this.onChange);
  }

  componentWillUnmount() {
    ScifiStore.unlisten(this.onChange);
  }

  onChange(state) {
    this.setState(state);
  }

  scifiAnswer(l){
    window.open(l,'_parent');
  }
  scifiFrame(link){
    return (
        <iframe
          sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
          style={{"width":'100%',"min-height": 900 }}
          src={link}>
        </iframe>
    )
  }



  render() {
    let sample = this.props.sample;
    let links = this.state.links;
    let lastLink = this.state.lastLink || {};
    if ( lastLink.elementId != this.props.sample.id){  lastLink= {};}
    return (
      <div style={{width:100+'%'}}>
        <br/>
        <ButtonToolbar><ButtonGroup justified>
          <ButtonGroup><ScifiQueryButton  element={sample} params={{searchType : 'exact'}}       /> </ButtonGroup>
          <ButtonGroup><ScifiQueryButton  element={sample} params={{searchType : 'substructure'}}/> </ButtonGroup>
          <ButtonGroup><ScifiQueryButton  element={sample} params={{searchType : 'similarity'}}  /> </ButtonGroup>
        </ButtonGroup></ButtonToolbar>

        <ScifiLinkButton linkElement={lastLink}/>
        <br/>
        <h5>Search History</h5>
          {links.map((l,i)=><ScifiLinkButton linkElement={l} key={l.key}/>) }
      </div>
    )
  }

}
