import { LightningElement, api } from 'lwc';

export default class ImageTile extends LightningElement {

    @api image;
    @api selected;
    url;
    get classes() {
        const classList = ['tile'];

        if (this.selected === true) { classList.push('tile--selected'); }

        return classList.join(' ');
    }
    connectedCallback() {
        this.addEventListener('click', this.handleClick);
       // this.addEventListener('mousemove', this.handleMouseMove);
        this.url = this.image.thumbnailUrl;
    }

    disconnectedCallback() {
        this.removeEventListener('click', this.handleClick);
       // this.removeEventListener('mousemove', this.handleMouseMove);
    }

    handleClick = () => {
        this.dispatchEvent(new CustomEvent('select', {
            bubbles: true,
            cancelable: true,
            composed: true,
            detail: {
                id: this.image.id,
            }
        }));
    }

    // handleMouseMove = ({clientX, clientY}) => {
    //     const tooltip = this.template.querySelector('.tooltip');

    //     tooltip.style.left = `${clientX + 20}px`;
    //     tooltip.style.top = `${clientY + 20}px`;
    // }

}