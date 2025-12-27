// external-links-icon.gjs

import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.decorateCooked((cooked, $post) => {
    if ($post?.querySelectorAll) setTimeout(() => addIcons($post), 150);
  });
  
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      mutation.addedNodes.forEach((node) => {
        if (node.nodeType === 1 && (node.matches?.('.cooked') || node.querySelector?.('.cooked'))) {
          setTimeout(() => addIcons(node), 100);
        }
      });
    });
  });
  observer.observe(document.body, { childList: true, subtree: true });
  
  function addIcons(container) {
    container.querySelectorAll('a[href]:not([data-ext-icon])').forEach(link => {
      const href = link.getAttribute('href');
      if (!href?.startsWith('http')) return;
      if (link.matches('a.hashtag, a.mention, [data-user-card], a.onebox, .breadcrumb a, a.back')) return;
      
      // Use Discourse's BUILT-IN featured link SVG sprite
      const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
      svg.setAttribute('class', 'fa d-icon d-icon-up-right-from-square svg-icon svg-string ext-icon');
      svg.setAttribute('aria-hidden', 'true');
      svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
      svg.innerHTML = '<use href="#up-right-from-square"></use>';
      
      link.appendChild(svg);
      link.setAttribute('data-ext-icon', 'true');
    });
  }
});
