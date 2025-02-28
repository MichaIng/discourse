export const FLOAT_UI_PLACEMENTS = [
  "top",
  "top-start",
  "top-end",
  "right",
  "right-start",
  "right-end",
  "bottom",
  "bottom-start",
  "bottom-end",
  "left",
  "left-start",
  "left-end",
];

export const TOOLTIP = {
  options: {
    animated: true,
    arrow: true,
    beforeTrigger: null,
    closeOnClickOutside: true,
    closeOnEscape: true,
    closeOnScroll: true,
    component: null,
    content: null,
    identifier: null,
    interactive: false,
    listeners: false,
    maxWidth: 350,
    data: null,
    offset: 10,
    triggers: ["hover", "click"],
    untriggers: ["hover", "click"],
    placement: "top",
    fallbackPlacements: FLOAT_UI_PLACEMENTS,
    autoUpdate: true,
    trapTab: true,
  },
  portalOutletId: "d-tooltip-portal-outlet",
};

export const MENU = {
  options: {
    animated: true,
    arrow: false,
    beforeTrigger: null,
    closeOnEscape: true,
    closeOnClickOutside: true,
    closeOnScroll: false,
    component: null,
    content: null,
    identifier: null,
    interactive: true,
    listeners: false,
    maxWidth: 400,
    data: null,
    offset: 10,
    triggers: ["click"],
    untriggers: ["click"],
    placement: "bottom",
    fallbackPlacements: FLOAT_UI_PLACEMENTS,
    autoUpdate: true,
    trapTab: true,
  },
  portalOutletId: "d-menu-portal-outlet",
};

import DDefaultToast from "float-kit/components/d-default-toast";

export const TOAST = {
  options: {
    autoClose: true,
    forceAutoClose: false,
    duration: 3000,
    component: DDefaultToast,
  },
};
