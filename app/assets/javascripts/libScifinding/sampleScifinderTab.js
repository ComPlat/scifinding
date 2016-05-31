import React, {Component} from 'react';
import {  ListGroupItem,   Tab} from 'react-bootstrap';
import SampleDetailsTabHook from './SampleDetailsTabHook';

export default  function sampleScifinderTab(ind){
    let sample = this.state.sample || {}
  //  console.log('plugin:'+sample.title())
    return(
      <Tab eventKey={ind}  tab={<img src="/images/signInLogo.png" style={{"maxHeight":25}}></img>} >
        <ListGroupItem style={{paddingBottom: 20}}>
           <SampleDetailsTabHook  sample={sample}/>
         </ListGroupItem>
       </Tab>
    )
  }
