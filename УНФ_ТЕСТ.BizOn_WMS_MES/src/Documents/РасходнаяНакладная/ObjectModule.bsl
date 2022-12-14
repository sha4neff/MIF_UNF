
&ИзменениеИКонтроль("ОбработкаПроведения")
Процедура БЗ_ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	// Взаиморасчеты
	СоответствиеТабличныхЧастейИРеквизитаЗаказ = Новый Соответствие;
	СоответствиеТабличныхЧастейИРеквизитаЗаказ.Вставить("Запасы", "Заказ");
	ДополнительныеСвойства.Вставить("ИмяРеквизитаЗаказ", "Заказ");
	РасчетыПроведениеДокументов.ИнициализироватьДополнительныеСвойстваДляПроведения(ЭтотОбъект, ДополнительныеСвойства, Отказ, Ложь, СоответствиеТабличныхЧастейИРеквизитаЗаказ);
	// Конец Взаиморасчеты

	// Инициализация данных документа.
	Документы.РасходнаяНакладная.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	// Взаиморасчеты
	// Проверим, можно ли продолжать и не было ли отказа в процедурах
	// формирования движений по взаиморасчетам.
	Отказ = ДополнительныеСвойства.Отказ;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	// Конец Взаиморасчеты

	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыВРазрезеГТД(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыПереданныеВРазрезеГТД(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыПринятыеВРазрезеГТД(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьВыпускПродукции(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыКРасходуСоСкладов(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыПринятые(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасыПереданные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыОтложенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьПотребностьВЗапасах(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРазмещениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);

	// СерийныеНомера
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераГарантии(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераОстатки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьСерийныеНомераКРасходу(ДополнительныеСвойства, Движения, Отказ);

	// ПодарочныеСертификаты
	УправлениеНебольшойФирмойСервер.ОтразитьПодарочныеСертификаты(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаПодарочнымиСертификатами(ДополнительныеСвойства, Движения, Отказ);

	// ДисконтныеКарты
	УправлениеНебольшойФирмойСервер.ОтразитьПродажиПоДисконтнойКарте(ДополнительныеСвойства, Движения, Отказ);
	// АвтоматическиеСкидки
	УправлениеНебольшойФирмойСервер.ОтразитьПредоставленныеСкидки(ДополнительныеСвойства, Движения, Отказ);
	// Эквайринг
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетодЭквайринг(ДополнительныеСвойства, Движения, Отказ);

	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);

	// Биллинг
	УправлениеНебольшойФирмойСервер.ОтразитьВыполнениеДоговораОбслуживания(ДополнительныеСвойства, Движения, Отказ);

	// Суммы документов для регламентированного учета
	УправлениеНебольшойФирмойСервер.ОтразитьСуммыДокументовРегламентированныйУчет(ДополнительныеСвойства, Движения, Отказ);

	// Взаиморасчеты
	УправлениеНебольшойФирмойСервер.ОтразитьЗакупкиДляКУДиР(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ, "ОплатаДокументов");
	УправлениеНебольшойФирмойСервер.ОтразитьОплатаСчетовИЗаказов(ДополнительныеСвойства, Движения, Отказ);
	// Конец Взаиморасчеты

	// Интеркампани
	УправлениеНебольшойФирмойСервер.ОтразитьРезервыТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	// Конец Интеркампани

	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	Если ДополнительныеСвойства.Свойство("ТаблицаДокументовДляИзменения")
		И ДополнительныеСвойства.ТаблицаДокументовДляИзменения.Количество() > 0
		Тогда
		РасчетыПроведениеДокументов.ОбработатьТаблицуДокументовДляИзмененияПриОтгрузке(ДополнительныеСвойства, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// Контроль возникновения отрицательного остатка.
#Удаление
	Документы.РасходнаяНакладная.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
#КонецУдаления
#Вставка
Если не ПараметрыСеанса.БЗ_ПроводитьБезКонтроляОстатков Тогда
	Документы.РасходнаяНакладная.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецЕсли;

#КонецВставки

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры
