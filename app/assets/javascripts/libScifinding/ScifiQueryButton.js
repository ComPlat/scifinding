import React, {Component} from 'react';
import {Badge,Button,  Glyphicon} from 'react-bootstrap';
import ScifiActions from './actions/ScifiActions';



export default class ScifiQueryButton extends Component {

  constructor(props) {
    super(props);

  }

  scifiQuery(params){
    let element = this.props.element || {}
    let elementType = element.type;
    let elementTitle, svgPath, molfile;

    if (element.type == "sample"){
      molfile = element.molecule.molfile;
      svgPath = element.molecule && element.molecule.molecule_svg_file || undefined;
      elementTitle = element.short_label ;
    } else if (elementType == "reaction"){
      svgPath =params.svgs;//element.reaction_svg_file;
      elementTitle = element.short_label || element.name || undefined;
    } else {
      svgPath= undefined;
    }

    let otherParams = {searchType: params.searchType, elementTitle: elementTitle,  elementId: element.id, elementType: element.type, svgPath: svgPath};
    switch (element.type) {
      case 'sample':
        ScifiActions.updateSf71({mdl: molfile,...params},otherParams);
        break;
      case 'reaction':
        ScifiActions.updateSf72({...params},otherParams);
        break;
    }
  }


  render() {
    let params = {...this.props.params , elementId: this.props.element.id};
    let searchType=params.searchType[1];
    let bkgd = {};
    if (searchType == 'x'){bkgd ={backgroundColor:'green'};}
    else if (searchType == 'u'){bkgd ={backgroundColor:'blue'};}
    else if (searchType == 'i'){bkgd ={backgroundColor:'black'};}
    return (
      <Button bsSize="small" bsStyle="default" onClick={() => this.scifiQuery(params)}>
          <Badge style={bkgd}>  <Glyphicon glyph="search" /></Badge><h5> {params.searchType}</h5>
      </Button>
    )
  }

}
