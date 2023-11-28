//
//  JavaScript.swift
//  SearchResultsParser
//
//  Created by Alfredo Colon on 11/27/23.
//

import Foundation

struct JavaScript {
    struct SearchResultsPage {
        static let jsondSearchResults =
        """
        class SearchResult {
            buyingOptions = {
                link: null,
                linkPath: null,
                listedCount: -1,
                all: null
            };
            condition = "new";
            delivery = {
                prime: false,
                option1: null,
                option2: null
            };
            imgsrc = null;
            price = {
                current: null,
                original: null,
                coupon: null
            };
            productPage = {
                title: null,
                path: null
            };
            rating = {
                stars: null,
                totalReviews: "0"
            };

            constructor(element, page, index)
            {
                this.element = element
                this.page = page;
                this.index = index;

                this.#updateBuyingOptions()
                this.#updateDelivery()
                this.#updateImgsrc()
                this.#updateRating()
                this.#updatePrice()
                this.#updateProductPage()
            }

            #updateBuyingOptions()
            {
                let link = this.element.querySelector("span[data-action='s-show-all-offers-display'] a");

                if (link != null) {
                    this.buyingOptions.link = link
                    this.buyingOptions.linkPath = "https://www.amazon.com" + link.getAttribute("href")

                    let innerText = link.parentElement.parentElement.innerText

                    if (innerText != null) {
                        var split = innerText.split("\\n")
                        if (split.length > 1) {
                            split = split[1].split("(")
                            this.buyingOptions.lowestPrice = split[0]

                            split = split[1].split(" ")[0]
                            if (split.length > 0) {
                                let number = Number(split[0])
                                if (number != NaN) {
                                    this.buyingOptions.listedCount = number
                                }
                            }
                        }
                    }
                }
            }

            #updateDelivery()
            {
                if (this.element.querySelector("i.a-icon.a-icon-prime.a-icon-medium") != null) {
                    this.delivery.prime = true
                }

                let spans = this.element.querySelectorAll("div.a-section.a-spacing-none.a-spacing-top-micro")
                let deliveryContainers = [...spans].filter(function del(element) {
                    let innerText = element.innerText
                    if (innerText == null)
                        return false;
                    if (innerText.includes("delivery"))
                        return true;
                });
                if (deliveryContainers.length == 0)
                    return;

                let deliveryContainer = deliveryContainers[0]
                let split = deliveryContainer.innerText.split("\\n")

                let text = split[0].trim()
                if (text.length > 0) {
                    this.delivery.option1 = text
                }

                if (split.length > 1) {
                    let text = split[1].trim()
                    if (this.delivery.option1 == null) {
                        this.delivery.option1 = text
                    } else {
                        this.delivery.option2 = text
                    }
                }

            }

            #updateImgsrc()
            {
                const img = this.element.querySelector("img") // [1].textContent
                if (img != null) {
                    this.imgsrc = img.getAttribute("src")
                }
            }

            #updatePrice()
            {
                const span = this.element.querySelector("span.a-offscreen")
                if (span != null) {
                    this.price.current = span.textContent.trim()// if (span.parentElement == null) return;
                    var sibling = span.parentElement.nextElementSibling
                    while (sibling != null) {
                        if (sibling.textContent.includes("List")) {
                            this.price.original = sibling.querySelector("span.a-offscreen").textContent.trim()
                            return
                        }

                        sibling = sibling.nextElementSibling
                    }
                }

                // coupon
                let innerText = this.element.innerText
                let split = innerText.split("\\n")
                let couponStrings = split.filter(function mentionsCoupon(string) {
                    return string.includes("coupon")
                });
                console.trace(couponStrings)
                if (couponStrings.length > 0) {
                    this.price.coupon = couponStrings[0].trim()
                }
            }

            #updateProductPage()
            {
                const link = this.element.querySelector("h2 a");
                if (link != null) {
                    const href = link.getAttribute("href");

                    this.productPage.path = "https:www.amazon.com" + href
                    this.productPage.title = link.textContent.trim()
                }
            }

            #updateRating()
            {
                let divs = this.element.querySelectorAll("div.a-row.a-size-small");
                let containers = [...divs].filter(function del(element) {
                    let innerText = element.innerText
                    if (innerText == null)
                        return false;
                    if (innerText.includes("stars"))
                        return true;
                });
                if (containers.length == 0)
                    return;

                let container = containers[0]
                
                let split = container.innerText.split(" ")
                let first = split[0]
                let stars = Number(first)
                if (stars != NaN) {
                    this.rating.stars = first.trim()
                }
                if (split.length > 1) {
                    let last = split[split.length - 1]
                    let totalRatingsNumber = Number(last)
                    if (totalRatingsNumber != NaN) {
                        this.rating.totalReviews = last.trim()
                    }
                    
                }
            }
        }
        function pageNumber() {
            let page = document.querySelector("span.s-pagination-item.s-pagination-selected")
            if (page != null) {
                let text = page.textContent
                if (text != null) {
                    let number = Number(text)
                    if (number != NaN) {
                        return number
                    }
                }
            }
        }
        function getSearchResults() {
            let page = pageNumber()
            let elements = document.querySelectorAll("div[data-component-type='s-search-result']");
            let searchResults = [...elements].map((element, index) => new SearchResult(element, page, index))

            return searchResults
        }

        JSON.stringify(getSearchResults())
        """
    }
    
    static let nextPagePath =
    """
        let element = document.querySelector("a.s-pagination-item.s-pagination-next.s-pagination-button.s-pagination-separator")
        if (element != null) {
            element.getAttribute("href")
        }
        
    """
    
    static let resultsCount =
    """
    function resultsCount() {
        let element = document.querySelector("div.a-section.a-spacing-small.a-spacing-top-small")
        if (element == null) return;

        let innerText = element.innerText
        if (innerText == null) return;

        let split = innerText.split(" ")
        console.trace(split)
        for (var i = 0; i < split.length; i++) {
            console.log(split[i])
            if (split[i].includes("results")) {
                console.log(split[i])
                while (--i > -1) {
                    console.log("< result\t", split[i])
                    let num = Number(split[i].replace(",", ""))
                    if (num != NaN) {
                        return num
                    }
                }
            }
        }
    }

    resultsCount()
    """
}
