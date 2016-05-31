import React, {Component} from 'react';
import SVG from 'react-inlinesvg';

export default class ElementsTableEntriesTd extends Component {
  constructor(props) {
      super();
    }

  render(){
    let element = this.props.element

    if (element.tags && element.tags.scifinder) {
      let tagSci = element.tags.scifinder;
      let count = tagSci.count;
      let updated = tagSci.updated;
      let source = "/images/favicon_scifi_stroke_bw.ico.svg";
      let title = count+' hits '+updated;
      if (count > 0) {source = "/images/favicon_scifi.ico.svg" }
      return(
        <img src={source} title={title} style={{"maxHeight":25}}></img>
      )
    } else {
      return (
      <div/>
      )
    }


  }

}
