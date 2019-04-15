/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  eran <email>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef NEGOTIATOR_H
#define NEGOTIATOR_H

#include <QObject>

/**
 * @todo write docs
 */
class negotiator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)
    Q_PROPERTY(int fps READ fps WRITE setFps NOTIFY fpsChanged)
    Q_PROPERTY(QPoint resolution READ resolution WRITE setResolution NOTIFY resolutionChanged)


public:
    /**
     * Copy Constructor
     *
     * @param other TODO
     */
    negotiator(const negotiator& other);

    /**
     * Destructor
     */
    ~negotiator();

    /**
     * @todo write docs
     *
     * @param watched TODO
     * @param event TODO
     * @return TODO
     */
    virtual bool eventFilter(QObject* watched, QEvent* event);

    /**
     * @return the orientation
     */
    orientation() const;

    /**
     * @return the fps
     */
    int fps() const;

    /**
     * @return the resolution
     */
    QPoint resolution() const;

	/**
	 *
	 */
	Q_INVOKABLE void negotiate();

public Q_SLOTS:
    /**
     * Sets the orientation.
     *
     * @param orientation the new orientation
     */
    void setOrientation(int orientation );

    /**
     * Sets the fps.
     *
     * @param fps the new fps
     */
    void setFps(int fps);

    /**
     * Sets the resolution.
     *
     * @param resolution the new resolution
     */
    void setResolution(const QPoint& resolution);

Q_SIGNALS:
    void orientationChanged(int orientation);

    void fpsChanged(int fps);

    void resolutionChanged(const QPoint& resolution);

protected:
    /**
     * @todo write docs
     *
     * @param event TODO
     * @return TODO
     */
    virtual void timerEvent(QTimerEvent* event);

    /**
     * @todo write docs
     *
     * @param event TODO
     * @return TODO
     */
    virtual void childEvent(QChildEvent* event);

private:
    m_orientation;
    int m_fps;
    QPoint m_resolution;
};

#endif // NEGOTIATOR_H
