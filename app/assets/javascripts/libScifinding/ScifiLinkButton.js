import React, {Component} from 'react';
import SVG from 'react-inlinesvg';
import { Badge, Button, Glyphicon, Col, Row, Panel } from 'react-bootstrap';
import ScifiStore from './stores/ScifiStore';
import ElementStore from 'components/stores/ElementStore';

const badgeCount = (count) => {
  return count ?
   <Badge style={{backgroundColor: count > 0 ? 'green' : 'red'}}> {count} </Badge> : null
}

const getSVG = ({elementId, elementType, svgPath}) => {
  const classNames = 'molecule molecule-small';
  const key = elementType + elementId
  if (elementType == "sample") {
    return(
      <SVG key={key} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames} src={`/images/molecules/${svgPath}`}/>
    )
  }
  if (elementType == "reaction") {
    return ['reagents','products'].map((compounds)=>svgPath[compounds].map((e)=>
        <SVG key={e} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classNames} src={`/images/molecules/${e}`}/>
      )
    )
  }
  return null;
}

const bdcol = (s) => {
  if (!s) { return 'black'; }
    //exact search
  if (s[1] === 'x') { return 'green' }
  // substructure
  if (s[1] === 'u') { return 'blue' }
  //similarity (default)
  return 'black';
}

const ScifiLinkButton = ({ linkElement }) => {
  const { url, hitCount, elementTitle, searchType, message, status,  ...props } = linkElement;
  if (!status) { return null; }
  let info = <p></p>;
  if (status === 200) {
    info = <p> {badgeCount(hitCount)} on scifinder.cas.org</p>;
  } else {
    info = <p>  error {status} </p>;
  }
  const errorMessage = status === 401 ? 'Unauthorized - check your access token in Account Settings' : message;
  return(
    <Panel
      style={{ cursor: 'pointer', marginBottom: 0 }}
      onClick={()=> window.open(`${url}` , '_blank')}
    >
      <Row>
        <Col sm={4}>
          <h5 style={{ verticalAlign: 'middle', whiteSpace: 'normal'}} >
            <Badge style={{backgroundColor: bdcol(searchType)}}>  <Glyphicon glyph="search" /> </Badge>
            &nbsp;{elementTitle}
          </h5> {info}
        </Col>
        <Col sm={8} style={{ verticalAlign: 'middle'}}>
          {status === 200 ? getSVG(props) : errorMessage}
        </Col>
      </Row>
    </Panel>
  );
}

export default ScifiLinkButton
