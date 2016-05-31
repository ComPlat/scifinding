import React, {Component} from 'react';
import {Badge,Button, ButtonGroup, ButtonToolbar, Glyphicon} from 'react-bootstrap';
import ScifiStore from './stores/ScifiStore';
import ElementStore from 'components/stores/ElementStore';
import SVG from 'react-inlinesvg';

export default class ScifiLinkButton extends Component {

  constructor(props) {
    super(props);


  }

  componentDidMount() {

  }

  componentWillUnmount() {

  }

  onChange(state) {

  }

  getSVG(){
    let linkElement = this.props.linkElement ||{};
    let classNames = 'molecule well-molecule';
    let key = linkElement.elementType+linkElement.elementId ;
    if (linkElement.elementType == "sample") {

      return(
        <SVG key={key} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames}    src={`/images/molecules/${linkElement.svgPath}`}/>
      )
    } else if (linkElement.elementType == "reaction") {
      return ['reagents','products'].map((compounds)=>linkElement.svgPath[compounds].map((e)=>
          <SVG key={key} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames}    src={`/images/molecules/${e}`}/>
        )
      )
    } else {return null}
  }
  badgeCount(count){
    let bkgdcol = {backgroundColor:'green'};
    if (count == 0){bkgdcol = {backgroundColor:'red'};}
    if (count){
      return(
        <Badge style={bkgdcol}> {count} </Badge>
      )
    } else {return null}
  }

  linkButton(){
    let linkElement = this.props.linkElement ||{};
    let link = linkElement.answerLink;//this.state.answerLink;
    let count = linkElement.hitCount; //this.state.hitCount;
    let title = linkElement.elementTitle;
    let searchType = linkElement.searchType || 'sim';

    let bdcol = (s)=>{
       if (s == 'x'){return {backgroundColor:'green'};}
       else if (s == 'u'){return {backgroundColor:'blue'};}
       else if (s == 'i'){return {backgroundColor:'black'};}
    }

    return(
      <ButtonToolbar><ButtonGroup justified><ButtonGroup>
        <Button bsSize="xsmall" bsStyle="default"
          style={{cursor: 'pointer'}}
          target='scifinder'
          href={link}>
          <h5 style={{ verticalAlign: 'middle'}} ><Badge style={bdcol(searchType[1])}>  <Glyphicon glyph="search" /> </Badge>
          {this.getSVG()} {title}:  {this.badgeCount(count)} on scifinder.cas.org</h5>
        </Button>
      </ButtonGroup></ButtonGroup></ButtonToolbar>
    )
  }
  errorButton(){
    let linkElement = this.props.linkElement ||{};
    let status = linkElement.status;
    let link = linkElement.answerLink;
    let title = linkElement.elementTitle;
    let searchType = linkElement.searchType || 'sim';

    let bdcol = (s)=>{
       if (s == 'x'){return {backgroundColor:'green'};}
       else if (s == 'u'){return {backgroundColor:'blue'};}
       else if (s == 'i'){return {backgroundColor:'black'};}
    }

    if (status) {

    return(
      <ButtonToolbar><ButtonGroup justified><ButtonGroup>
        <Button bsSize="xsmall" bsStyle="default"
          style={{cursor: 'pointer'}}
          target='scifinder'
          href={link}>

          <h5 style={{ verticalAlign: 'middle'}} ><Badge style={bdcol(searchType[1])}>  <Glyphicon glyph="search" /> </Badge>
          {this.getSVG()} {title}:  error status: {status}</h5>
        </Button>
      </ButtonGroup></ButtonGroup></ButtonToolbar>
    ) }else { return null}
  }

  render() {
  //  let linkElement = this.props.linkElement ||{};
    let status = this.props.linkElement.status;


    if (status == 200){ return this.linkButton()
    } else {return this.errorButton()}

  }

}
