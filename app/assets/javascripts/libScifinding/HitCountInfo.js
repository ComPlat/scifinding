import React, {Component} from 'react';
import { Label} from 'react-bootstrap';
import SVG from 'react-inlinesvg';

export default class HitCountInfo extends Component {
  constructor(props) {
    super();
    }

  render(){
    let element = this.props.element
    if (element.tags && element.tags.scifinder) {
      let tagSci = element.tags.scifinder;
      let count = tagSci.count;
      let updated = tagSci.updated+")";
      let source = "/images/favicon_scifi_stroke_bw.ico.svg";
      let hit = ()=> { if (count == 1) {return " hit (";} else {return " hits ("}}
      let message =()=> "not found ("+updated ;
      if (count > 0) {source = "/images/favicon_scifi.ico.svg"; message = ()=>count+hit()+updated  }
      return(
        <Label style={{backgroundColor:'white',color:'grey', border: '1px solid grey'}}><img src={source} style={{"maxHeight":18}}/>{message()}</Label>
      )
    } else {
      return (
      <div/>
      )
    }


  }

}
