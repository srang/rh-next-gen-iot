import React, {Component} from 'react';
import summit from './img/summit.svg';
import './css/App.css';
import { Button } from 'patternfly-react';
import { AboutModal } from 'patternfly-react';

export class LabAboutModal extends Component {
    constructor() {
        super();
        this.state = { showModal: false };
        this.open = this.open.bind(this);
        this.close = this.close.bind(this);
    }
    open() {
        this.setState({ showModal: true });
    }
    close() {
        this.setState({ showModal: false });
    }
    render() {
        return (
            <div>
                <Button bsStyle="primary" bsSize="large" onClick={this.open}>
                    {this.props.buttonTitle}
                </Button>

                <AboutModal
                    show={this.state.showModal}
                    onHide={this.close}
                    productTitle="Next Gen Technologies at Scale"
                    logo={summit}
                    altLogo="Red Hat Summit 2019 Logo"
                    trademarkText="github.com/ablock/something"
                >
                    <AboutModal.Versions>
                        <AboutModal.VersionItem label="Presenter" versionText="Sam Rang" />
                        <AboutModal.VersionItem label="Presenter" versionText="Andrew Block" />
                        <AboutModal.VersionItem label="Presenter" versionText="Ishu Verma" />
                        <AboutModal.VersionItem label="Presenter" versionText="Hugo Guerrero Olivares" />
                        <AboutModal.VersionItem label="Presenter" versionText="Christina Lin" />
                    </AboutModal.Versions>
                </AboutModal>
            </div>
        );
    }
}

