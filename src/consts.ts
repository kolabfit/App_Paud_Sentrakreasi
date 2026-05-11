// Place any global data in this file.
// You can import this data from anywhere in your site by using the `import` keyword.
// Base Page Metadata, src/layouts/BaseLayout.astro
export const BRAND_NAME = "Komunitas Halal Bandung";
export const SITE_TITLE = "Komunitas Halal Bandung Repository";
export const SITE_DESCRIPTION = "Repository Komunitas Halal Bandung";
export const LOGO_URL = "/logo.png";
export const BRAND_EMAIL = "komunitashalalbandung@gmail.com";
export const LOCATION_URL_EMBED =
  "https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d990.0438737440439!2d107.652457!3d-6.988599!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e68e9e9e0fb20c7%3A0xc2b331f47416ac3d!2sGriya%20Permata%20Asri!5e0!3m2!1sid!2sid!4v1733818644367!5m2!1sid!2sid%22%20width=%22600%22%20height=%22450%22%20style=%22border:0;%22%20allowfullscreen=%22%22%20loading=%22lazy%22%20referrerpolicy=%22no-referrer-when-downgrade%22";
export const LOCATION_URL = "https://maps.app.goo.gl/jDAnncoEmYFKeGf2A";
export const BRAND_PHONE = "+62 856-2394-568";
export const BRAND_WHATSAPP_URL =
  "https://api.whatsapp.com/send?phone=628562394568&text=halo%20saya%20ingin%20bertanya%20tentang%20komunitas%20halal%20bandung";
export const BRAND_INSTAGRAM_URL =
  "https://www.instagram.com/komunitashalal.bdg?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==";

// Tags Page Metadata, src/pages/tags/index.astro
export const Tags_TITLE = "AstroVerse - All Tags";
export const Tags_DESCRIPTION =
  "AstroVerse - All tags and the count of articles related to each tag";

// Tags Page Metadata, src/pages/tags/[tag]/[page].astro
export function getTagMetadata(tag: string) {
  return {
    title: `All articles on '${tag}' tag in AstroVerse`,
    description: `Explore articles about ${tag} for different perspectives and in-depth analysis.`,
  };
}

// Category Page Metadata, src/pages/category/[category]/[page].astro
export function getCategoryMetadata(category: string) {
  return {
    title: `All articles in '${category}' category in AstroVerse`,
    description: `Browse all articles under the ${category} category in AstroVerse`,
  };
}

// Header Links, src/components/Header.astro
export const CategoryLinks = [
  { href: "/category/Instagram/1/", title: "Instagram" },
  { href: "/category/Powerpoint/1/", title: "Powerpoint" },
  { href: "/category/Tiktok/1/", title: "Tiktok" },
  { href: "/category/Whatsapp/1/", title: "Whatsapp" },
];

export const PrintCategoryLinks = [
  { href: "/category/X Banner/1/", title: "X Banner" },
  { href: "/category/Flyer/1/", title: "Flyer" },
  { href: "/category/Poster/1/", title: "Poster" },
  { href: "/category/Kartu Nama/1/", title: "Kartu Nama" },
];

export const HeaderLinks = {
  Contact: { href: "/contact/", title: "Kontak" },
  Home: { href: "/", title: "Home" },
  Request: { href: "/request/", title: "Request Template" },
};

// // Footer Links, src/components/Footer.astro
// export const FooterLinks = [
//   { href: "mailto:" + BRAND_EMAIL, title: "Email" },
//   {}
// ];

// Social Links, src/components/Footer.astro
export const SocialLinks = [
  {
    href: BRAND_INSTAGRAM_URL,
    icon: "tabler:brand-instagram",
    label: "Instagram",
  },
  {
    href: BRAND_WHATSAPP_URL,
    icon: "tabler:brand-whatsapp",
    label: "Whatsapp",
  },
  {
    href: LOCATION_URL,
    icon: "tabler:map-pin",
    label: "Location",
  },
  {
    href: "mailto:" + BRAND_EMAIL,
    icon: "tabler:mail",
    label: "Email",
  },
];

// Search Page Metadata, src/pages/search.astro
export const SEARCH_PAGE_TITLE = `${SITE_TITLE} - Site Search`;
export const SEARCH_PAGE_DESCRIPTION = `Search all content on ${SITE_TITLE}`;
