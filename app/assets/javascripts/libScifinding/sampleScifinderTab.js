import React, {Component} from 'react';
import {  ListGroupItem,   Tab} from 'react-bootstrap';
import SampleDetailsTabHook from './SampleDetailsTabHook';

export default  function sampleScifinderTab(ind){
    let sample = this.state.sample || {}
    return(
      <Tab eventKey={ind}  tab={<img src="/images/sf_logo_text.png" style={{"maxHeight":25}}></img>} >
        <ListGroupItem style={{paddingBottom: 20}}>
           <SampleDetailsTabHook  sample={sample}/>
         </ListGroupItem>
       </Tab>
    )
  }
