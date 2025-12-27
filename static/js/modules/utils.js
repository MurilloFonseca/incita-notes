export const setLocalStorage = (key, val) => {
  const item = localStorage.getItem(key);

  localStorage.setItem(key, item ? "" : val);
}

export const addEvent = (cls, type, event) => {
  const el = document.querySelector(cls)

  if (el) {
    el.addEventListener(type, event)
  }
}
