import React, {Component} from 'react';
import {Badge,Button, ButtonGroup, ButtonToolbar, Glyphicon} from 'react-bootstrap';
import ScifiStore from './stores/ScifiStore';
import ElementStore from 'components/stores/ElementStore';
import SVG from 'react-inlinesvg';

const ScifiLinkButton = ({linkElement}) => {
  return linkElement.status == 200 ?
   linkButton(linkElement) : errorButton(linkElement)
}

const badgeCount = (count) => {
  return count ?
   <Badge style={{backgroundColor: count > 0 ? 'green' : 'red'}}> {count} </Badge> : null
}

const getSVG = ({elementId, elementType, svgPath}) => {
  let classNames = 'molecule well-molecule';
  let key = elementType+elementId
  if (elementType == "sample") {
    return(
      <SVG key={key} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames}    src={`/images/molecules/${svgPath}`}/>
    )
  } else if (elementType == "reaction") {
    return ['reagents','products'].map((compounds)=>svgPath[compounds].map((e)=>
        <SVG key={key} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames}    src={`/images/molecules/${e}`}/>
      )
    )
  } else {return null}
}

const bdcol = (s) =>{
  if (s) {
    //exact search
    if (s[1] == 'x'){return 'green'}
    // substructure
    else if (s[1] == 'u'){return 'blue'}
    //similarity (default)
    else {return 'black'}
  }
  else {return 'black'}
}


const linkButton = ({url, hitCount, elementTitle, searchType, ...props}) =>{
  return(
    <ButtonToolbar><ButtonGroup justified><ButtonGroup>
      <Button bsSize="xsmall" bsStyle="default"
        style={{cursor: 'pointer'}}
        target='scifinder'
        href={url}>
        <h5 style={{ verticalAlign: 'middle'}} >
          <Badge style={{backgroundColor: bdcol(searchType)}}>  <Glyphicon glyph="search" /> </Badge>
          &nbsp;{elementTitle} {badgeCount(hitCount)} on scifinder.cas.org</h5>
        {getSVG(props)}
      </Button>
    </ButtonGroup></ButtonGroup></ButtonToolbar>
  )
}

const errorButton = ({status, url, message, searchType, ...linkElement}) => {
  return( status ?
    <ButtonToolbar><ButtonGroup justified><ButtonGroup>
      <Button bsSize="xsmall" bsStyle="default"
        style={{cursor: 'pointer'}}
        target='scifinder'
        href={url}>
        <h5 style={{ verticalAlign: 'middle', whiteSpace: 'normal'}} >
          <Badge style={{backgroundColor: bdcol(searchType)}}> <Glyphicon glyph="search"/> </Badge>
          &nbsp;error {status}: {message}</h5>{getSVG(linkElement)}
      </Button>
    </ButtonGroup></ButtonGroup></ButtonToolbar>
   : null )
}

export default ScifiLinkButton
