//
//  FlickrLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/11/18.
//

import UIKit

private let patternTotalCellsCount = 4
private let patternColumnsCount = 2
private let visibleSmallRowsCount = 5
private let visibleLargeRowsCount = 4

public class FlickrLayout: ContentDynamicLayout {

    // MARK: - ContentDynamicLayout
    
    override public func calculateCollectionViewCellsFrames() {
        guard let collectionView = collectionView else {
            return
        }
        
        contentSize.width = collectionView.frame.size.width

        let heightWithoutPadding = collectionView.frame.height - 2 * contentPadding.vertical - cellsPadding.vertical
        let largeHorizontalCellHeight = heightWithoutPadding / CGFloat(visibleLargeRowsCount)
        let smallHorizontalCellHeight = heightWithoutPadding / CGFloat(visibleSmallRowsCount)
        let smallVerticalCellHeight = 2 * smallHorizontalCellHeight + cellsPadding.vertical
        let smallCellWidth = (contentWidthWithoutPadding - cellsPadding.horizontal) / CGFloat(patternColumnsCount)

        let smallHorizontalCellSize = CGSize(width: smallCellWidth, height: smallHorizontalCellHeight)
        let smallVerticalCellSize = CGSize(width: smallCellWidth, height: smallVerticalCellHeight)
        let largeHorizontalCellSize = CGSize(width: contentWidthWithoutPadding, height: largeHorizontalCellHeight)

        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let remainder = item % patternTotalCellsCount
                let isLastRow = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if remainder == 0 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallHorizontalCellSize)

                    if isLastRow {
                        yOffset += smallHorizontalCellHeight
                    }
                } else if remainder == 1 {
                    let x = smallCellWidth + contentPadding.horizontal + cellsPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallVerticalCellSize)

                    yOffset += isLastRow ? smallVerticalCellHeight : smallHorizontalCellHeight
                    yOffset += cellsPadding.vertical
                } else if remainder == 2 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallHorizontalCellSize)

                    yOffset += smallHorizontalCellHeight + cellsPadding.vertical
                } else if remainder == 3 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: largeHorizontalCellSize)

                    yOffset += largeHorizontalCellHeight + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
