import React, {Component} from 'react';
import SVG from 'react-inlinesvg';

export default class ElementsTableEntriesTd extends Component {
  constructor(props) {
      super();
    }

  render(){
    let element = this.props.element

    if (element.tags && element.tags.scifinder) {
      let tagSci = element.tags.scifinder
      let {count, updated} = tagSci
      let title = count+' hits '+updated

      return(
        <img src="/images/sf_logo_pur.png"
         title={title} style={{"maxHeight":25}}
         className={count > 0 ? null : 'sf_unknown'}/>
      )
    } else { return null }

  }

}
