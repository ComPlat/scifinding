import React, {Component} from 'react';
import {Badge,Button, ButtonGroup, ButtonToolbar, Glyphicon} from 'react-bootstrap';
import ScifiStore from './stores/ScifiStore';
import ScifiQueryButton from './ScifiQueryButton';
import ScifiLinkButton from './ScifiLinkButton';
import ElementStore from 'components/stores/ElementStore';


import SVG from 'react-inlinesvg';
import classnames from 'classnames';

// strip molfile V2000 after molecule end 'M  END'
const stripMolfile = (molfile) => {
  const splitted = molfile.split(/(^M  END)/m)
  if (splitted.length > 1) {
    return splitted.slice(0, 2).join('').concat("\n")
  }
  return ''
}

export default class ReactionDetailsTabHook extends Component {

  constructor(props) {
    super(props);
    //const {reaction} = props.reaction;
    let selection = {};
    [
      ...this.props.reaction._starting_materials.map((e)=>{return e.type+e.id;}),
      ...this.props.reaction._reactants.map((e)=>{return e.type+e.id;}),
      ...this.props.reaction._products.map((e)=>{return e.type+e.id;}),
    ].map((e)=>{ selection[e]=true;});
    this.state = {
      ...ScifiStore.getState(),
      ...selection,
    };

    this.onChange = this.onChange.bind(this)
  }

  componentDidMount() {
    ScifiStore.listen(this.onChange);
  }

  componentWillUnmount() {
    ScifiStore.unlisten(this.onChange);
  }

  onChange(state) {
    let selection = {};
    [
      ...this.props.reaction._starting_materials.map((e)=>{return e.type+e.id;}),
      ...this.props.reaction._reactants.map((e)=>{return e.type+e.id;}),
      ...this.props.reaction._products.map((e)=>{return e.type+e.id;}),
    ].map((e)=>{ selection[e]=true;});
    this.setState({...state});//,...selection,    };
    //({...this.state} = {...ScifiStore.getState()});
  }

  buildRxn(){
    let rxn = "$RXN\n\n\n\n";
    const molBreak = "$MOL\n";
    let rl = 0;
    let xl = 0;
    let pl = 0;
    let molfiles = "";
    let svgs ={reagents:[],products:[]};
    this.props.reaction._starting_materials.map((e)=>{
      if (this.state[e.type+e.id]) {
        ++rl;
        molfiles +=  molBreak + stripMolfile(e.molfile);
        svgs.reagents.push(e.molecule.molecule_svg_file);
      }
    });
    this.props.reaction._reactants.map((e)=>{
      if (this.state[e.type+e.id]) {
        ++xl;
        molfiles +=  molBreak + stripMolfile(e.molfile);
        svgs.reagents.push(e.molecule.molecule_svg_file);
      }
    });
    this.props.reaction._products.map((e)=>{
      if (this.state[e.type+e.id]) {
        ++pl;
        molfiles +=  molBreak + stripMolfile(e.molfile);
        svgs.products.push(e.molecule.molecule_svg_file);
      }
    });

    rxn += ("   " + (rl+xl).toString()).slice( -3);
    rxn += ("   " + pl.toString()).slice( -3);
//  rxn += ("   " + 0).slice( -3);
    rxn += "\n"
    rxn += molfiles;

    return {rxn: rxn, svgs: svgs};
  }

  moleculeSelector(){

    let reagents  = this.props.reaction._starting_materials//.map((e)=>e._molecule.molecule_svg_file) ||[];
    let reactants = this.props.reaction._reactants//.map((e)=>e._molecule.molecule_svg_file) || [];
    let products  = this.props.reaction._products//.map((e)=>e._molecule.molecule_svg_file) || [];

    return  (
      <ButtonToolbar><ButtonGroup justified>

          {reagents.map((e,i)=>{return this.buttonSVG(`/images/molecules/${e._molecule.molecule_svg_file}`,e.type+e.id);})}
          {reactants.map((e,i)=>{return this.buttonSVG(`/images/molecules/${e._molecule.molecule_svg_file}`,e.type+e.id);})}
            <ButtonGroup>  <Button style={{borderWidth:0}}><Glyphicon glyph="arrow-right" /></Button>  </ButtonGroup>
          {products.map((e,i)=>{return this.buttonSVG(`/images/molecules/${e._molecule.molecule_svg_file}`,(e.type+e.id));})}

      </ButtonGroup></ButtonToolbar>
    )
  }

  buttonSVG(svgPath,id){
      let classes = classnames({
        sf_reaction_selector: true ,
        sf_sample_off: !this.state[id]
      });

    return(
      <ButtonGroup  key={"btGrp"+id} >
        <Button className={'sf-reaction-button'}  style={{ cursor:'pointer'}} onClick={() =>{this.toggleSelection(id)}}>
          <SVG key={id} uniquifyIDs={true} style={{ verticalAlign: 'middle'}} className={classes}    src={svgPath}/>
        </Button>
      </ButtonGroup>
    )
  }

  toggleSelection(id){
    let newState = {};
    if (this.state[id]) {
      newState[id]=false;
      this.setState(newState);
    } else {
      newState[id]=true;
      this.setState(newState);
    }
  }

  render() {
    let reaction = this.props.reaction;
    let links = this.state.links;
    let lastLink = this.state.lastLink;
    if ( lastLink.elementId != this.props.reaction.id){  lastLink= {};}
    let rxn = this.buildRxn();

    return (
      <div>
        <br/>

          <p style={{textAlign:'center'}}>
            Get reactions where the structures are
          </p>
          <ButtonToolbar><ButtonGroup justified>
            <ButtonGroup>
              <ScifiQueryButton element={reaction} params={{...rxn ,
                searchType: 'variable only at the specific position'}}/>
            </ButtonGroup>
            <ButtonGroup>
              <ScifiQueryButton element={reaction} params={{...rxn,
                searchType: 'substructures of more complex molecules'}}/>
            </ButtonGroup>
          </ButtonGroup></ButtonToolbar>

        <br/>
        {this.moleculeSelector()}
        <ScifiLinkButton linkElement={lastLink}/>
        <br/>
        <h5>Search History</h5>
          {links.map((l)=><ScifiLinkButton linkElement={l} key={l.key}/>) }
      </div>
    )
  }

}
