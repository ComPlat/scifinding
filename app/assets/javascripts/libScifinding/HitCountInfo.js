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
      let {count,updated} = element.tags.scifinder
      let message = count >  0
        ? count + " hit" + (count > 1 ? "s" :"") + " (" + updated + ")"
        : "not found (" + updated + ")"

      return(
        <Label style={{backgroundColor:'white',color:'grey', border: '1px solid grey'}}>
          <img src="/images/sf_logo_pur.png"
            style={{"maxHeight":18}}
            className={count > 0 ? null : 'sf_unknown'}/>
          {message}
        </Label>
      )
    } else {return null}
  }

}
