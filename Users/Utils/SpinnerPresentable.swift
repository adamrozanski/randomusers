//
//  SpinnerPresentable.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import UIKit
import RPCircularProgress

protocol SpinnerPresentable: class {

    func addSpinner(hidden: Bool, blurStyle: UIBlurEffectStyle, offset: CGPoint)
    func removeSpinner()
    func showSpinner()
    func hideSpinner()
}

extension UIView: SpinnerPresentable {

    private var containerSize: CGSize  { return CGSize(width: 200, height: 130) }
    private var circleSize: CGSize { return CGSize(width: 50, height: 50) }
    private var circleProgressViewTag: Int { return 989 }
    private var spinnerViewTag: Int { return 678 }

    internal func addSpinner(hidden: Bool, blurStyle: UIBlurEffectStyle = .extraLight, offset: CGPoint = CGPoint(x: 0, y: -40)) {
        let spinner = getSpinnerView(blurStyle: blurStyle)
        spinner.center = self.center
        spinner.isHidden = hidden
        self.addSubview(spinner)
        let constraints: [NSLayoutConstraint] = [
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: offset.x),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: offset.y)
        ]
        NSLayoutConstraint.activate(constraints)
        hidden ? stopAnimating() : startAnimating()
    }

    internal func removeSpinner() {
        getSpinnerView(in: self)?.removeFromSuperview()
    }

    internal func showSpinner() {
        setSpinnerHidden(false)
    }

    internal func hideSpinner() {
        setSpinnerHidden(true)
    }

    private func setSpinnerHidden(_ hidden: Bool) {
        getSpinnerView(in: self)?.isHidden = hidden
        hidden ? stopAnimating() : startAnimating()
    }

    private func startAnimating() {
        getCircularProgressView(in: self)?.enableIndeterminate(true, completion: nil)
    }

    private func stopAnimating() {
        getCircularProgressView(in: self)?.enableIndeterminate(false, completion: nil)
    }

    private func getSpinnerView(blurStyle: UIBlurEffectStyle) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 16.0
        container.translatesAutoresizingMaskIntoConstraints = false
        let circle = createCircularProgressView()
        container.addSubview(circle)
        let label = createLabel()
        container.addSubview(label)
        let constraints: [NSLayoutConstraint] = [
            container.heightAnchor.constraint(equalToConstant: containerSize.height),
            container.widthAnchor.constraint(equalToConstant: containerSize.width),
            circle.heightAnchor.constraint(equalToConstant: circleSize.height),
            circle.widthAnchor.constraint(equalToConstant: circleSize.width),
            circle.topAnchor.constraint(equalTo: container.topAnchor, constant: 25),
            circle.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
        container.tag = spinnerViewTag
        addBlur(to: container, style: blurStyle)
        return container
    }

    private func addBlur(to view: UIView, style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        view.insertSubview(vibrancyView, at: 1)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vibrancyView.heightAnchor.constraint(equalTo: view.heightAnchor),
            vibrancyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            vibrancyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vibrancyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    private func createCircularProgressView() -> RPCircularProgress {
        let circle = RPCircularProgress()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.progressTintColor = UIColor.gray
        circle.tintColor = UIColor.gray.withAlphaComponent(0.4)
        circle.thicknessRatio = 0.1
        circle.tag = circleProgressViewTag
        return circle
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = Strings.fetching
        label.attributedText = Strings.fetching.toAttributedStringWithFont(.systemFont(ofSize: 15), color: UIColor.black.withAlphaComponent(0.5), backgroundColor: .clear)
        return label
    }

    private func getCircularProgressView(in parent: UIView) -> RPCircularProgress? {
        if let spinnerView = getSpinnerView(in: parent) {
            return getViewWithTag(circleProgressViewTag, in: spinnerView) as? RPCircularProgress
        }
        return nil
    }

    private func getSpinnerView(in parent: UIView) -> UIView? {
        return getViewWithTag(spinnerViewTag, in: parent)
    }

    private func getViewWithTag(_ tag: Int, in parent: UIView) -> UIView? {
        return parent.subviews.filter({ $0.tag == tag }).first
    }

}
