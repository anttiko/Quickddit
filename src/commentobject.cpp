/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

#include "commentobject.h"

#include <QtCore/QSharedData>
#include <QtCore/QDateTime>

class CommentObjectData : public QSharedData
{
public:
    CommentObjectData() : score(0), likes(0), distinguished(CommentObject::NotDistinguished),
        depth(0), isSubmitter(false), isScoreHidden(false), visibility(CommentObject::Visible) {}

    QString fullname;
    QString author;
    QString body;
    QString rawBody;
    int score;
    int likes;
    QDateTime created;
    QDateTime edited;
    CommentObject::DistinguishedType distinguished;
    int depth;
    bool isSubmitter;
    bool isScoreHidden;
    CommentObject::CommentVisibility visibility;

private:
    Q_DISABLE_COPY(CommentObjectData)
};

CommentObject::CommentObject()
    : d(new CommentObjectData)
{
}

CommentObject::CommentObject(const CommentObject &other)
    : d(other.d)
{
}

CommentObject &CommentObject::operator =(const CommentObject &other)
{
    d = other.d;
    return *this;
}

CommentObject::~CommentObject()
{
}

QString CommentObject::fullname() const
{
    return d->fullname;
}

void CommentObject::setFullname(const QString &fullname)
{
    d->fullname = fullname;
}

QString CommentObject::author() const
{
    return d->author;
}

void CommentObject::setAuthor(const QString &author)
{
    d->author = author;
}

QString CommentObject::body() const
{
    return d->body;
}

void CommentObject::setBody(const QString &body)
{
    d->body = body;
}

QString CommentObject::rawBody() const
{
    return d->rawBody;
}

void CommentObject::setRawBody(const QString &rawBody)
{
    d->rawBody = rawBody;
}

int CommentObject::score() const
{
    return d->score;
}

void CommentObject::setScore(int score)
{
    d->score = score;
}

int CommentObject::likes() const
{
    return d->likes;
}

void CommentObject::setLikes(int likes)
{
    d->likes = likes;
}

QDateTime CommentObject::created() const
{
    return d->created;
}

void CommentObject::setCreated(const QDateTime &created)
{
    d->created = created;
}

QDateTime CommentObject::edited() const
{
    return d->edited;
}

void CommentObject::setEdited(const QDateTime &edited)
{
    d->edited = edited;
}

CommentObject::DistinguishedType CommentObject::distinguished() const
{
    return d->distinguished;
}

void CommentObject::setDistinguished(CommentObject::DistinguishedType distinguished)
{
    d->distinguished = distinguished;
}

void CommentObject::setDistinguished(const QString &distinguishedString)
{
    if (distinguishedString.isEmpty())
        d->distinguished = NotDistinguished;
    else if (distinguishedString == "moderator")
        d->distinguished = DistinguishedByModerator;
    else if (distinguishedString == "admin")
        d->distinguished = DistinguishedByAdmin;
    else if (distinguishedString == "special")
        d->distinguished = DistinguishedBySpecial;
}

int CommentObject::depth() const
{
    return d->depth;
}

void CommentObject::setDepth(int depth)
{
    d->depth = depth;
}

bool CommentObject::isSubmitter() const
{
    return d->isSubmitter;
}

void CommentObject::setSubmitter(bool submitter)
{
    d->isSubmitter = submitter;
}

bool CommentObject::isScoreHidden() const
{
    return d->isScoreHidden;
}

void CommentObject::setScoreHidden(bool scoreHidden)
{
    d->isScoreHidden = scoreHidden;
}

void CommentObject::setVisibility(CommentVisibility v)
{
    d->visibility = v;
}

CommentObject::CommentVisibility CommentObject::visibility() const
{
    return d->visibility;
}
